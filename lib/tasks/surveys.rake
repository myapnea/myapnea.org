namespace :surveys do

  desc "Automatically launch followup encounters for users who have filled out a corresponding baseline survey"
  task launch_followup_encounters: :environment do
    Survey.launch_followup_encounters
  end

  desc "Add default user to all existing surveys"
  task add_user: :environment do
    original_surveys_user_id = 1
    Survey.where(slug: nil).each do |s|
      s.update_column :user_id, original_surveys_user_id
    end

    newer_surveys_user_id = 2
    Survey.where.not(slug: nil).each do |s|
      s.update_column :user_id, newer_surveys_user_id
    end
    Question.all.each do |q|
      q.update_column :user_id, newer_surveys_user_id
    end
    AnswerTemplate.all.each do |at|
      at.update_column :user_id, newer_surveys_user_id
    end
    AnswerOption.all.each do |ao|
      ao.update_column :user_id, newer_surveys_user_id
    end
  end

  desc "Update all `AnswerTemplate`s with a template name based on their questions display type, and their own data type."
  task update_answer_templates: :environment do
    AnswerTemplate.where.not(parent_answer_option_value: nil).order(:id).each do |at|
      question = at.questions.first
      current_index = question.answer_templates.where(parent_answer_template_id: nil).pluck(:id).index(at.id) if question
      if current_index and current_index > 0 and parent_template = question.answer_templates.where(parent_answer_template_id: nil)[current_index - 1]
        at.update_column :parent_answer_template_id, parent_template.id
      end
    end

    AnswerTemplate.all.each do |at|
      at.set_template_name!
    end
  end

  desc "Add default baseline encounter."
  task add_baseline_encounter: :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE encounters RESTART IDENTITY")
    owner = User.where(owner: true).first
    baseline = Encounter.create(user_id: owner.id, name: 'Baseline', slug: 'baseline', launch_days_after_sign_up: 0)
    Survey.all.each do |s|
      s.survey_encounters.create(user: s.user, encounter: baseline)
    end
  end

  desc "Add default user types to all existing surveys."
  task add_user_types_to_surveys: :environment do
    s = Survey.find_by_slug 'about-me'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_adult'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_child'

    s = Survey.find_by_slug 'additional-information-about-me'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_adult'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_child'

    s = Survey.find_by_slug 'about-my-family'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_adult'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_child'

    s = Survey.find_by_slug 'my-interest-in-research'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_adult'
    s.survey_user_types.create user_id: s.user_id, user_type: 'caregiver_child'

    s = Survey.find_by_slug 'my-health-conditions'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'

    s = Survey.find_by_slug 'my-sleep-pattern'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'

    s = Survey.find_by_slug 'my-sleep-quality'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'

    s = Survey.find_by_slug 'my-quality-of-life'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'

    s = Survey.find_by_slug 'my-sleep-apnea'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'

    s = Survey.find_by_slug 'my-sleep-apnea-treatment'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_diagnosed'

    s = Survey.find_by_slug 'my-risk-profile'
    s.survey_user_types.create user_id: s.user_id, user_type: 'adult_at_risk'
  end

  desc "Remove duplicate answers and answer values"
  task remove_duplicate_answers_and_answer_values: :environment do
    def answer_session_duplicates_count
      answer_session_count = AnswerSession.joins("LEFT OUTER JOIN answers ON answer_sessions.id = answers.answer_session_id").group(:answer_session_id, :question_id).having("COUNT(answers.id) > 1").pluck(:answer_session_id).uniq.count
      puts "AnswerSessions with duplicate answers #{answer_session_count} out of TOTAL COUNT #{AnswerSession.count}"
      answer_count = AnswerSession.joins("LEFT OUTER JOIN answers ON answer_sessions.id = answers.answer_session_id").group(:answer_session_id, :question_id).having("COUNT(answers.id) > 1").pluck(:answer_session_id).count
      puts "Answers with validation errors #{answer_count} out of TOTAL COUNT #{Answer.count}"
      puts "AnswerValues missing parent #{AnswerValue.where(answer_id: nil).count}"
    end

    answer_session_duplicates_count

    AnswerSession.joins("LEFT OUTER JOIN answers ON answer_sessions.id = answers.answer_session_id").group(:answer_session_id, :question_id).having("COUNT(answers.id) > 1").pluck(:answer_session_id).each do |answer_session_id|
      as = AnswerSession.find answer_session_id
      puts as.id

      as.answers.group(:question_id).having("COUNT(answers.id) > 1").count.each do |question_id, count|
        puts "\n"
        puts "QUESTION_ID: #{question_id} has #{count} answers"
        puts "\n"
        answers = as.answers.where(question_id: question_id)

        puts answers.pluck(:id, :updated_at)

        max_updated_at = answers.pluck(:updated_at).max

        answers.where.not(updated_at: max_updated_at).each do |answer|
          puts "Deleting Answer #{answer.id}"
          answer.answer_values.delete_all
          answer.delete
        end
      end
    end

    answer_session_duplicates_count
  end

  desc "Set default locked_at time for answer sessions."
  task add_locked_at_to_answer_sessions: :environment do
    AnswerSession.where(locked: true, locked_at: nil).each do |answer_session|
      answer_session.update locked_at: answer_session.updated_at
    end
  end

end
