# frozen_string_literal: true

# Groups together a series of surveys and a consent.
class Project < ApplicationRecord
  # Constants
  THEMES = [
    %w(Default default),
    %w(Sunset sunset),
    %w(Night night),
    %w(Blue blue),
    %w(Green green),
    %w(Orange orange)
  ]

  # Concerns
  include Deletable
  include Latexable
  include Sluggable

  # Scopes
  scope :published, -> { current.where(published: true) }

  # Validations
  validates :name, :access_token, :slice_site_id, :code_prefix, presence: true
  validates :slug, format: { with: /\A[a-z][a-z0-9\-]*\Z/ },
                   exclusion: { in: %w(new edit create update destroy research) },
                   uniqueness: true,
                   allow_nil: true

  # Relationships
  belongs_to :user
  has_many :subjects

  # Methods
  def destroy
    update slug: nil
    super
  end

  def subjects_count
    remote_subjects.size
  end

  # Returns array of [:user_id, :subject_code] pairs.
  def remote_subjects
    @remote_subjects ||= begin
      subjects = []
      page = 1
      loop do
        new_subjects = subjects_on_page(page)
        subjects += new_subjects
        page += 1
        break unless new_subjects.size == 20
      end
      subjects
    end
  end

  def all_subject_codes
    @all_subject_codes ||= begin
      all_codes = []
      page = 1
      loop do
        new_subject_codes = subjects_on_page(page).collect(&:second)
        all_codes += new_subject_codes.reject { |c| (/^#{code_prefix}\d{5}$/ =~ c).nil? }
        page += 1
        break unless new_subject_codes.size == 20
      end
      all_codes
    end
  end

  def subjects_on_page(page)
    params = { page: page }
    (json, _status) = Slice::JsonRequest.get("#{project_url}/subjects.json", params)
    return [] unless json
    subjects = json.collect do |subject_json|
      [subject_json["id"], subject_json["subject_code"]]
    end
    subjects
  end

  def project_url
    "#{ENV["slice_url"]}/api/v1/projects/#{access_token}"
  end

  def generate_subject_code
    "#{code_prefix}#{format("%05d", next_subject_code_number)}"
  end

  def next_subject_code_number
    highest_subject_code_number + 1
  end

  def highest_subject_code_number
    all_subject_codes.collect { |c| c.gsub(code_prefix, "").to_i }.max || 0
  end

  # Print Consent
  def latex_partial(partial)
    File.read(File.join("app", "views", "projects", "latex", "_#{partial}.tex.erb"))
  end

  def generate_printed_pdf!(subject)
    jobname = subject ? "consent_#{subject.id}" : "consent"
    output_folder = File.join("tmp", "files", "tex")
    FileUtils.mkdir_p output_folder
    file_tex = File.join("tmp", "files", "tex", "#{jobname}.tex")
    @project = self
    @subject = subject # Needed by Binding
    File.open(file_tex, "w") do |file|
      file.syswrite(ERB.new(latex_partial("header")).result(binding))
      file.syswrite(ERB.new(latex_partial("consent")).result(binding))
      file.syswrite(ERB.new(latex_partial("footer")).result(binding))
    end
    Project.generate_pdf(jobname, output_folder, file_tex)
  end
end
