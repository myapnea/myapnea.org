namespace :dictionary do
  desc 'Export data dictionary'
  task export: :environment do
    tmp_folder = Rails.root.join('tmp', 'dictionary')

    FileUtils.mkdir_p tmp_folder

    export_csv_path = File.join(tmp_folder, "variables.csv")

    CSV.open(export_csv_path, 'wb') do |csv|
      csv << ["folder", "id", "display_name", "description", "type", "units", "domain", "labels", "calculation"]

      Survey.viewable.includes(questions: [ answer_templates: :answer_options]).each do |survey|
        survey.questions.each do |question|
          if question.display_type == 'radio_input_multiple'
            question.answer_templates.each do |at|
              slug = at.name
              display_name = at.text.to_s.chomp

              answer_options = at.answer_options.pluck(:value, :text)

              csv << [survey.slug, slug, display_name, nil, 'radio_input', nil, answer_options.sort{|a, b| a[0] <=> b[0]}.collect{|ao| "#{ao[0]}: #{ao[1]}"}.join(' | '), nil, nil]
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

            csv << [survey.slug, slug, display_name, nil, question.display_type, unit, answer_options.sort{|a, b| a[0] <=> b[0]}.collect{|ao| "#{ao[0]}: #{ao[1]}"}.join(' | '), nil, nil]

            question.answer_templates.where(data_type: 'text_value').each do |at|
              slug = at.name
              ao = answer_options.select{|value, text| value == at.parent_answer_option_value}.first
              display_name = if ao
                ao[1]
              else
                nil
              end
              csv << [survey.slug, slug, display_name, nil, 'text_value', nil, nil, nil, nil]
            end

          end
        end
      end
    end
  end

  desc 'Export data in data dictionary format'
  task data_export: :environment do
    tmp_folder = Rails.root.join('tmp', 'dictionary')

    FileUtils.mkdir_p tmp_folder

    export_csv_path = File.join(tmp_folder, 'data.csv')

    CSV.open(export_csv_path, 'wb') do |csv|
      row = ['encounter']
      question_slugs = []

      Survey.current.viewable.non_pediatric.includes(questions: [answer_templates: :answer_options]).each do |survey|
        survey.questions.each do |question|
          if question.display_type == 'radio_input_multiple'
            question.answer_templates.each do |at|
              slug = at.name
              question_slugs << slug
            end
          else
            slug = question.slug
            question_slugs << slug
            question.answer_templates.where(data_type: 'text_value').each do |at|
              slug = at.name
              question_slugs << slug
            end
          end
        end
      end

      csv << (row + question_slugs)

      User.include_in_exports_and_reports.order(:id).each do |user| # .where(id: 3703)
        puts "Exporting User ##{user.id}"
        encounters = ['baseline']
        encounters.each do |encounter|
          row = [encounter]
          question_slugs.each do |slug|
            # r = Report.where(user_id: user.id, encounter: encounter).where("question_slug = ? or answer_template_name = ?", slug, slug).first
            # row << if r
            #   if r.value.present?
            #     r.value
            #   elsif r.answer and r.answer.answer_values.collect{|av| av.answer_option}.compact.count > 0
            #     r.answer.answer_values.collect{|av| av.answer_option}.compact.collect{|ao| ao.value}.uniq.sort.join(', ')
            #   else
            #     nil
            #   end
            # else
            #   nil
            # end
          end
          csv << row
        end
      end
    end
  end
end
