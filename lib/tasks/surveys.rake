namespace :surveys do
  namespace :deprecated do

    SEQUENCE_VALUE = 10000000

    desc "Truncate survey tables and create reserved id space for survey model tables by setting sequence startpoint"
    task :setup_db => :environment do
      survey_tables = [
          "answer_options",
          "answer_templates",
          "display_types",
          "groups",
          "questions",
          "surveys",
          "question_help_messages",
          "units"
      ]

      survey_tables.each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
        ActiveRecord::Base.connection.execute("SELECT SETVAL('#{table}_id_seq', #{SEQUENCE_VALUE})")
      end
    end

    desc "Update all survey models except for question edges."
    task :update_questions => :environment do
      if warn_user
        tables_to_update = [
            "answer_options",
            "answr_options_answer_templates",
            "answer_templates",
            "answer_templates_questions",
            "display_types",
            "groups",
            "questions",
            "surveys",
            "question_help_messages",
            "units"
        ]

        join_tables = [
            "answr_options_answer_templates",
            "answer_templates_questions"
        ]


        clean_tables(tables_to_update)
        clean_join_tables(join_tables)

        files = [
            ["units.yml", Unit],
            ["groups.yml", Group],
            ["display_types.yml", DisplayType],
            ["answer_options.yml", AnswerOption],
            ["answer_templates.yml", AnswerTemplate],
            ["question_help_messages.yml", QuestionHelpMessage],
            ["questions.yml", Question],
            ["surveys.yml", Survey]
        ]



        files.each do |file_name, model_class|
          file_path = Rails.root.join('lib', 'data', 'myapnea', 'surveys', file_name)

          puts(file_path)

          yaml_data = YAML.load_file(file_path)

          yaml_data.each do |object_attrs|
            puts object_attrs
            model_class.create(object_attrs)
          end
        end
      end
    end

    # TODO: MAKE THIS OPERATION SAFER FOR EXISTING ANSWER DATA
    desc "Update question edges."
    task :update_question_edges => :environment do
      if warn_user                        #      ActiveRecord::Base.connection.execute("SELECT SETVAL('#{table}_id_seq', 100000000)")

        clean_join_tables(["question_edges"])

        qe_path = Rails.root.join('lib', 'data', 'myapnea', 'surveys', 'question_edges.yml')

        puts(qe_path)

        yaml_data = YAML.load_file(qe_path)

        yaml_data.each_with_index do |attrs, i|

          q1 = Question.find(attrs['parent_question_id'])
          q2 = Question.find(attrs['child_question_id'])

          qe = QuestionEdge.build_edge(q1, q2, attrs['condition'], attrs['survey_id'])

          puts("Creating edge #{i+1} of #{yaml_data.length} between #{q1.id} and #{q2.id}")
          raise StandardError, qe.errors.full_messages unless qe.save
        end
      end

    end

    desc "Updates questions and question edges."
    task :update => :environment do
      Rake::Task["surveys:update_questions"].invoke
      Rake::Task["surveys:update_question_edges"].invoke
      Rake::Task["surveys:refresh"].invoke
    end

    desc "Updates questions and question edges."
    task :create => :environment do
      Rake::Task["surveys:setup_db"].invoke
      Rake::Task["surveys:update"].invoke
      Rake::Task["surveys:refresh"].invoke

    end



    desc "Update links"
    task :migrate_old_survey => :environment do
      user_count = User.count
      User.order("created_at asc").each_with_index do |user, index|
        puts "Migrating user (#{index+1} of #{user_count}) #{user.email}"
        old_answer_session = user.answer_sessions.where(survey_id: 13).first

        if old_answer_session
          Survey.viewable.each do |survey|
            puts "Migrating survey #{survey.name}"

            answer_session = AnswerSession.find_or_create_by(user_id: user.id, survey_id: survey.id)
            answer_session.reset_answers if answer_session.completed?

            question = survey.first_question

            until answer_session.completed?
              old_answer = question.answers.where(answer_session_id: old_answer_session.id).first

              if old_answer and old_answer.string_value.present?
                new_answer = answer_session.process_answer(question, {question.id.to_s => old_answer.string_value})
              else
                new_answer = answer_session.process_answer(question, {})
              end
              question = new_answer.next_question
            end

          end
        end
      end

    end


    desc "Migrate over answers from old survey to one afflicted with bug"
    task :fix_about_me_survey_migration => :environment do
      user_count = User.count
      survey = Survey.find(16)
      User.order("created_at asc").each_with_index do |user, index|
        puts "Migrating user (#{index+1} of #{user_count}) #{user.email}"
        old_answer_session = user.answer_sessions.where(survey_id: 13).first

        if old_answer_session

            puts "Migrating survey #{survey.name}"

            answer_session = AnswerSession.find_by(user_id: user.id, survey_id: survey.id)

            if answer_session and answer_session.started?
              question = answer_session.last_answer.next_question
            end

            while question.present?
              new_answer = question.answers.where(answer_session_id: answer_session.id).first
              old_answer = question.answers.where(answer_session_id: old_answer_session.id).first

              if new_answer.blank?
                if old_answer and old_answer.string_value.present?
                  new_answer = answer_session.process_answer(question, {question.id.to_s => old_answer.string_value})
                else
                  new_answer = answer_session.process_answer(question, {})
                end
              end

              question = new_answer.next_question
            end
        end
      end

    end


    def clean_tables(tables)
      tables.each do |table|
        ActiveRecord::Base.connection.execute("DELETE FROM #{table} where id < #{SEQUENCE_VALUE}")
      end



    end

    def clean_join_tables(tables)
      tables.each do |table|
        ActiveRecord::Base.connection.execute("truncate #{table}")
      end
    end

    def warn_user
      puts "WARNING: Any major changes to the ids or structure of the survey data will likely invalidate previously done answer sessions."
      puts "Are you sure you want to continue? (y/n)"

      STDIN.gets.strip.downcase == 'y'

    end
  end

  desc "Refresh Precalculated data"
  task :refresh => :environment do
    Survey.refresh_all_surveys

    AnswerSession.current.each {|as| as.completed? }
  end


  desc "Load a specific survey"
  task :load, [:survey_name] => :environment  do |t, args|
    Survey.load_from_file(args[:survey_name])

  end

  desc "Migrate old questions for a specific survey"
  task :migrate_old_answers, [:survey_slug] => :environment  do |t, args|
    Survey.migrate_old_answers(args[:survey_name])
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
