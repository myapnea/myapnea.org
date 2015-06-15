namespace :dictionary do
  desc "Export data dictionary"
  task export: :environment do

    tmp_folder = Rails.root.join('tmp', 'dictionary')

    FileUtils.mkdir_p tmp_folder

    export_csv_path = File.join(tmp_folder, "variables.csv")

    CSV.open(export_csv_path, 'wb') do |csv|
      csv << ["folder", "id", "display_name", "description", "type", "units", "domain", "labels", "calculation"]


      Survey.viewable.includes(ordered_questions: [ answer_templates: :answer_options]).each do |survey|
        survey.questions.each do |question|
          if question.display_type == 'radio_input_multiple'
            question.answer_templates.each do |at|
              slug = at.name
              display_name = at.text.to_s.chomp

              answer_options = at.answer_options.pluck(:value, :text)

              csv << [survey.slug, slug, display_name, nil, 'radio_input', nil, answer_options.collect{|ao| "#{ao[0]}: #{ao[1]}"}.join(' | '), nil, nil]
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

            csv << [survey.slug, slug, display_name, nil, question.display_type, unit, answer_options.collect{|ao| "#{ao[0]}: #{ao[1]}"}.join(' | '), nil, nil]

            question.answer_templates.where(data_type: 'text_value').each do |at|
              slug = at.name
              display_name = at.text.to_s.chomp
              csv << [survey.slug, slug, display_name, nil, 'text_value', nil, nil, nil, nil]
            end

          end
        end
      end

    end

  end
end
