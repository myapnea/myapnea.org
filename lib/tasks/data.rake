# frozen_string_literal: true

namespace :data do

  task ess: :environment do
    tmp_folder = File.join('tmp', 'pcornet')
    FileUtils.mkdir_p tmp_folder

    export_csv_path = File.join(tmp_folder, "ess.csv")


    user_values = {}
    survey = Survey.find_by_slug 'my-sleep-pattern'
    question = survey.questions.find_by_slug 'epworth-sleepiness-scale'
    answer_template_names = question.answer_templates.pluck(:name)

    answer_template_names.each do |answer_template_name|
      answer_template = AnswerTemplate.find_by_name answer_template_name

      values_and_ids = AnswerValue.where( answer_id: question.answers.pluck(:id), answer_template_id: answer_template.id ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_options.value", "answer_sessions.user_id")

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

      users = User.current.include_in_exports_and_reports
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


  task promis: :environment do
    tmp_folder = File.join('tmp', 'pcornet')
    FileUtils.mkdir_p tmp_folder

    export_csv_path = File.join(tmp_folder, "promis.csv")


    user_values = {}
    survey = Survey.find_by_slug 'my-sleep-quality'
    question_main = survey.questions.find_by_slug 'sleep-quality-week'


    question_others = survey.questions.find_by_slug 'sleep-quality-week-components'

    answer_template_names = question_main.answer_templates.pluck(:name) + question_others.answer_templates.pluck(:name)

    answer_template_names.each do |answer_template_name|
      answer_template = AnswerTemplate.find_by_name answer_template_name

      values_and_ids = AnswerValue.where( answer_id: question_main.answers.pluck(:id) + question_others.answers.pluck(:id), answer_template_id: answer_template.id ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_options.value", "answer_sessions.user_id")

      values_and_ids.each do |text, value, user_id|
        user_values[user_id.to_s] ||= {}
        # Reverse code some of the questions
        if answer_template_name.in?(["overall_sleep_quality", "sleep_refreshing", "satisfied_with_sleep"])
          new_value = case value when 1,2,3,4,5
            6 - value
          else
            nil
          end
        else
          new_value = case value when 1,2,3,4,5
            value
          else
            nil
          end
        end

        user_values[user_id.to_s][answer_template.name] = new_value
      end
      user_values.each do |key, hash|
        user_values[key]['Total PROMIS'] = (answer_template_names.sum{ |n| user_values[key][n] } rescue 'MISSING')
      end
    end

    CSV.open(export_csv_path, 'wb') do |csv|
      csv << ["Participant Code"] + answer_template_names + ['Total PROMIS']

      users = User.current.include_in_exports_and_reports
      users.each do |u|
        row = [u.id]
        if user_values[u.id.to_s]
          (answer_template_names + ['Total PROMIS']).each do |answer_template_name|
            row << user_values[u.id.to_s][answer_template_name]
          end
        end
        csv << row
      end
    end

  end

end
