# frozen_string_literal: true

# Groups together a series of surveys and a consent.
class Project < ApplicationRecord
  # Uploaders
  mount_uploader :consent_pdf, PDFUploader

  # Concerns
  include Deletable
  include Latexable
  include Sluggable

  # Scopes
  scope :published, -> { current.where(published: true) }

  # Validations
  validates :name, presence: true
  validates :access_token, :slice_site_id, :code_prefix, presence: true, unless: :external?
  validates :external_link, presence: true, if: :external?
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

  def generate_consent_pdf!
    jobname = "consent"
    temp_dir = Dir.mktmpdir
    temp_tex = File.join(temp_dir, "#{jobname}.tex")
    write_tex_file(temp_tex)
    self.class.compile(jobname, temp_dir, temp_tex)
    temp_pdf = File.join(temp_dir, "#{jobname}.pdf")
    update consent_pdf: File.open(temp_pdf, "r"), consent_pdf_file_size: File.size(temp_pdf) if File.exist?(temp_pdf)
  ensure
    # Remove the directory.
    FileUtils.remove_entry temp_dir
  end

  def write_tex_file(temp_tex)
    @project = self # Needed by binding
    File.open(temp_tex, "w") do |file|
      file.syswrite(ERB.new(latex_partial("header")).result(binding))
      file.syswrite(ERB.new(latex_partial("consent")).result(binding))
      file.syswrite(ERB.new(latex_partial("footer")).result(binding))
    end
  end
end
