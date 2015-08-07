namespace :surveys do

  namespace :answer_sessions do
    desc "Update cached locked value for answer sessions"
    task refresh: :environment do
      total = AnswerSession.current.count
      AnswerSession.current.each_with_index do |as, i|
        puts "Checking #{i+1} of #{total}"
        as.locked?
      end
    end

  end

  desc "Launch a survey for a given user group - [:survey_slug, :user_where_clause, :encounter]"
  task :launch, [:survey_slug, :user_where_clause, :encounter] => :environment do |t, args|
    user_group = User.current.where(args[:where_clause])
    survey = Survey.find_by_slug(args[:survey_slug])

    already_assigned = survey.launch_multiple(user_group, args[:encounter])

    puts "Total number of users in survey launch: #{user_group.length}\n
          Users with survey previously launched: #{already_assigned.length}\n
          List of users with survey previously launched:\n
          #{already_assigned}"
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
    AnswerTemplate.all.each do |at|
      at.set_template_name!
    end
  end

  desc "Add default baseline encounter to all existing surveys."
  task add_encounters_to_surveys: :environment do
    Survey.all.each do |s|
      s.send('create_default_encounters')
    end
  end

end
