namespace :data do

  desc "Export Survey data to CSV for use with PCORNET Common Data Model"
  task export: :environment do

    tmp_folder = File.join('tmp', 'pcornet')

    FileUtils.mkdir_p tmp_folder


    [CdmDemographic, CdmEnrollment, CdmVital, CdmEncounter, CdmProCm].each do |cdm_model|
      export_csv_path = File.join(tmp_folder, "#{cdm_model.table_name}.csv")

      CSV.open(export_csv_path, 'wb') do |csv|
        csv << cdm_model.column_names
        cdm_model.all.each do |db_row|
          csv << db_row.attributes.values
        end
      end
    end
  end


  task ess: :environment do
    tmp_folder = File.join('tmp', 'pcornet')
    FileUtils.mkdir_p tmp_folder

    export_csv_path = File.join(tmp_folder, "ess.csv")


    user_values = {}
    survey = Survey.find_by_slug 'my-sleep-pattern'
    question = survey.questions.find_by_slug 'epworth-sleepiness-scale'
    answer_template_names = %w(
      doze_while_sitting
      doze_while_watching_tv
      doze_while_public_sitting
      doze_while_passenger_in_car
      doze_while_lying_down_afternoon
      doze_while_sitting_talking
      doze_while_sitting_after_lunch
      doze_while_in_car_stopped)

    answer_template_names.each do |answer_template_name|
      answer_template = AnswerTemplate.find_by_name answer_template_name

      values_and_ids = AnswerValue.current.where( answer_id: question.answers.pluck(:id), answer_template_id: answer_template.id ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_options.value", "answer_sessions.user_id")

      values_and_ids.each do |text, value, user_id|
        user_values[user_id.to_s] ||= {}
        new_value = case value when 4,3,2,1
          4 - value
        else
          nil
        end

        user_values[user_id.to_s][answer_template.name] = new_value
      end
      user_values.each do |key, hash|
        user_values[key]['Total ESS'] = answer_template_names.sum{ |n| user_values[key][n].to_i }
      end
    end

    CSV.open(export_csv_path, 'wb') do |csv|
      csv << ["Participant Code"] + answer_template_names + ['Total ESS']

      users = User.current
      users.each do |u|
        row = [u.id]
        if user_values[u.id.to_s]
          (answer_template_names + ['Total ESS']).each do |answer_template_name|
            row << user_values[u.id.to_s][answer_template_name]
          end
        end
        csv << row
      end
    end

  end

end
