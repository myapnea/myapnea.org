class Admin::Export < ActiveRecord::Base
  # Uploaders
  mount_uploader :file, ZipUploader

  # Callbacks
  after_create :start_export_in_background

  # Concerns
  include Forkable

  # Model Validation
  validates :user_id, presence: true

  # Model Relationships
  belongs_to :user

  # Model Methods

  def name
    'EXPORT NAME'
  end

  private

  def number_of_steps
    exportable_users.count + 2
  end

  def start_export_in_background
    fork_process :start_export
  end

  def start_export
    update current_step: 0, total_steps: number_of_steps
    finalize_export generate_zip_file
  rescue => e
    export_failed e.message.to_s + e.backtrace.to_s
  end

  # Zip multiple files, or zip one file if it's part of the sheet uploaded
  # files, always zip folder
  def generate_zip_file
    filename = "myapnea-data-#{created_at.strftime('%H%M')}"
    all_files = generate_all_files(filename)

    return if all_files.empty?

    # Create a zip file
    zipfile_name = File.join('tmp', 'exports', "#{filename}-#{Digest::SHA1.hexdigest(Time.zone.now.usec.to_s)[0..8]}.zip")
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      all_files.uniq.each do |location, input_file|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(location, input_file) if File.exist?(input_file) && File.size(input_file) > 0
      end
    end
    zipfile_name
  end

  def generate_all_files(filename)
    export_data(filename) + export_data_dictionary(filename) + export_sas(filename)
  end

  def export_data(filename)
    data_csv = File.join('tmp', 'exports', "#{filename}-#{created_at.strftime('%I%M%P')}-data.csv")
    write_data_csv(data_csv)
    [["#{data_csv.split('/').last}", data_csv]]
  end

  def export_data_dictionary(filename)
    dictionary_csv = File.join('tmp', 'exports', "#{filename}-#{created_at.strftime('%I%M%P')}-dictionary.csv")
    write_data_dictionary_csv(dictionary_csv)
    [["#{dictionary_csv.split('/').last}", dictionary_csv]]
  end

  def export_sas(filename)
    sas_file = File.join('tmp', 'exports', "#{filename}-#{created_at.strftime('%I%M%P')}.sas")
    write_sas(sas_file)
    [["#{sas_file.split('/').last}", sas_file]]
  end

  def finalize_export(export_file)
    if export_file
      export_succeeded export_file
    else
      export_failed 'No files were added to zip file.'
    end
  end

  def export_succeeded(export_file)
    update status: 'completed',
           file: File.open(export_file),
           file_created_at: Time.zone.now,
           current_step: total_steps
    notify_user!
  end

  def export_failed(details)
    update status: 'failed', details: details
  end

  def notify_user!
    UserMailer.export_ready(self).deliver_later if Rails.env.production? # ENV['emails_enabled'] == 'true'
  end

  def write_data_csv(data_csv)
    CSV.open(data_csv, 'wb') do |csv|
      row = %w(id encounter)
      question_slugs = []
      surveys_answer_templates = []

      Survey.current.viewable.non_pediatric.includes(questions: [answer_templates: :answer_options]).each do |survey|
        survey.questions.each do |question|
          if question.display_type == 'radio_input_multiple'
            question.answer_templates.each do |at|
              slug = at.name
              question_slugs << slug
              surveys_answer_templates << [survey.id, question.id, at.id]
            end
          else
            slug = question.slug
            question_slugs << slug
            surveys_answer_templates << [survey.id, question.id, -1]
            question.answer_templates.where(data_type: 'text_value').each do |at|
              slug = at.name
              question_slugs << slug
              surveys_answer_templates << [survey.id, question.id, at.id]
            end
          end
        end
      end

      csv << (row + question_slugs)

      exportable_users.each do |user|
        encounters = ['baseline']
        encounters.each do |encounter|
          row = [user.id, encounter]
          surveys_answer_templates.each do |survey_id, question_id, answer_template_id|
            answer_session = user.answer_sessions.find_by_survey_id survey_id
            if answer_session
              values = AnswerValue.joins(:answer).where(answers: { answer_session_id: answer_session.id, question_id: question_id }).where(answer_template_id: answer_template_id).collect(&:show_value)
              row << values.collect(&:to_s).join(',')
            else
              row << nil
            end
          end
          csv << row
        end
        update current_step: current_step + 1
      end
    end
  end

  def write_data_dictionary_csv(dictionary_csv)
    CSV.open(dictionary_csv, 'wb') do |csv|
      csv << %w(folder id display_name description type units domain labels calculation)

      Survey.viewable.includes(questions: [answer_templates: :answer_options]).each do |survey|
        survey.questions.each do |question|
          if question.display_type == 'radio_input_multiple'
            question.answer_templates.each do |at|
              slug = at.name
              display_name = at.text.to_s.chomp

              answer_options = at.answer_options.pluck(:value, :text)

              csv << [survey.slug, slug, display_name, nil, 'radio_input', nil, answer_options.sort { |a, b| a[0] <=> b[0] }.collect { |ao| "#{ao[0]}: #{ao[1]}" }.join(' | '), nil, nil]
            end
          else
            slug = question.slug
            display_name = question.text_en.to_s.chomp

            answer_options = []
            question.answer_templates.each do |at|
              answer_options += at.answer_options.pluck(:value, :text)
            end

            if question.answer_templates.count == 1
              unit = question.answer_templates.first.unit
            end

            csv << [survey.slug, slug, display_name, nil, question.display_type, unit, answer_options.sort { |a, b| a[0] <=> b[0] }.collect { |ao| "#{ao[0]}: #{ao[1]}" }.join(' | '), nil, nil]

            question.answer_templates.where(data_type: 'text_value').each do |at|
              slug = at.name
              ao = answer_options.select { |value, _text| value == at.parent_answer_option_value }.first
              display_name = (ao ? ao[1] : nil)
              csv << [survey.slug, slug, display_name, nil, 'text_value', nil, nil, nil, nil]
            end
          end
        end
      end
    end
    update current_step: current_step + 1
  end

  def write_sas(sas_file)
    @export_formatter = self

    erb_file = File.join('app', 'views', 'admin', 'exports', 'sas_export.sas.erb')

    File.open(sas_file, 'w') do |file|
      file.syswrite(ERB.new(File.read(erb_file)).result(binding))
    end
    update current_step: current_step + 1
  end

  def exportable_users
    User.include_in_exports_and_reports.order(:id)
  end
end
