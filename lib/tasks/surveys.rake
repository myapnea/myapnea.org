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


end
