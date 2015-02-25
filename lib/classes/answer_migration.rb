=begin
  am = AnswerMigration.new()
=end

class AnswerMigration
  MAP_DIRECTORY = File.join(Rails.root, "lib", "data", "myapnea", "surveys", "answer_migration")

  def initialize(question_map = nil, answer_option_map=nil)
    @question_map = question_map if question_map and question_map.is_a?(Array)
    @question_map = YAML::load_file(question_map) if question_map and question_map.is_a?(String)
    @question_map ||= YAML.load_file(File.join(MAP_DIRECTORY, "question_mappings.yml"))

    @answer_option_map = answer_option_map if answer_option_map and answer_option_map.is_a?(Array)
    @answer_option_map = YAML::load_file(answer_option_map) if answer_option_map and answer_option_map.is_a?(String)
    @answer_option_map ||= YAML.load_file(File.join(MAP_DIRECTORY, "answer_option_mappings.yml"))

    raise StandardError, "Invalid question map" unless validate_question_map
    raise StandardError, "Invalid answer option map" unless validate_answer_option_map
  end

  def validate_question_map
    validation = true
    @question_map.each do |question_mapping|
      begin
        new_question = Question.find_by!(slug: question_mapping["slug"])
        new_question.answer_templates.find_by!(name: question_mapping["answer_template_name"])
        Question.find(question_mapping["id"].to_i)
      rescue => e
        puts "#{e.message} | #{question_mapping["slug"]} | #{question_mapping["answer_template_name"]} | #{question_mapping["id"]}"
        validation = false
      end

    end

    validation
  end

  def validate_answer_option_map
    validation = true

    @answer_option_map.each do |ao_mapping|
      begin
        AnswerOption.find(ao_mapping["old_option_id"])
        new_template = AnswerTemplate.find_by!(name: ao_mapping["new_template_name"])
        new_template.answer_options.find_by!(value: ao_mapping["new_option_value"])

      rescue => e
        puts "#{e.message} | #{ao_mapping["old_option_id"]} | #{ao_mapping["new_template_name"]} | #{ao_mapping["new_option_value"]}"
        validation = false
      end
    end

    validation
  end

  def set_answer_option_mappings(output_dir)
    csv_file = CSV.open(File.join(output_dir, "summary.csv"), 'w')
    map_file = File.open(File.join(output_dir, "mappings.yml"), 'w')

    csv_file << ['NEW_QUESTION', 'NEW_TEMPLATE', 'OLD_QUESTION_ID', 'NEW_TYPE', 'OLD_TYPE', 'RESOLVED?', 'OLD_VALUE', 'MATCHED_VALUE', 'EXACT?', 'NEW_LIST']

    @question_map.each do |question_mapping|
      new_question = Question.find_by_slug(question_mapping["slug"])
      new_answer_template = new_question.answer_templates.find_by_name(question_mapping["answer_template_name"])
      old_question = Question.find(question_mapping["id"].to_i)

      old_question.answer_templates.each do |old_answer_template|
        if new_answer_template.data_type == "answer_option_id"
          # CATEGORICAL - NEW ANSWER
          if old_answer_template.data_type == "answer_option_id"
            # CATEGORICAL - OLD ANSWER

            # Both are categorical - let's try to match up
            option_list = new_answer_template.answer_options
            option_text_list = option_list.map(&:text)
            option_matcher = FuzzyMatch.new(option_text_list)

            map_file.write "\n# #{new_question.slug} : #{old_question.id} : #{new_answer_template.name} \n# #{option_list.map{|o| "#{o.value} : #{o.text}"}.join(" | ")}\n"

            old_answer_template.answer_options.each do |answer_option|
              matched_option_text = option_matcher.find(answer_option.text_value)
              puts "#{old_question.id} | #{new_answer_template.id} | #{answer_option.value} : #{matched_option_text}"
              matched_answer_option = option_list.where(text: matched_option_text).first

              stripped_matched = matched_option_text.strip if matched_option_text
              stripped_text = answer_option.text_value.strip if answer_option.text_value
              same = stripped_matched == stripped_text

              csv_file << [new_question.slug, new_answer_template.name, old_question.id, "categorical", "categorical", "yes", stripped_text, stripped_matched, same] + option_text_list


              map_file.write "- old_option_id: #{answer_option.id} # #{answer_option.text_value.strip}\n"
              map_file.write "  new_template_name: #{new_answer_template.name} # #{matched_option_text.strip if matched_option_text}\n"
              map_file.write "  new_option_value: #{matched_answer_option.value if matched_answer_option}\n"

              #map_file.write "  new_option_id: #{matched_answer_option.id if matched_answer_option} # #{matched_option_text.strip if matched_option_text}\n"
            end
          else
            csv_file << [new_question.slug, new_answer_template.name, old_question.id, "categorical", old_answer_template.data_type, "no"]
          end

        else
          # CUSTOM VALUE - NEW ANSWER

          if old_answer_template.data_type == new_answer_template.data_type
            # Old and New match types
            csv_file << [new_question.slug, new_answer_template.name, old_question.id, new_answer_template.data_type, old_answer_template.data_type, "yes"]
          else
            # Old and New do not match types
            csv_file << [new_question.slug, new_answer_template.name, old_question.id, new_answer_template.data_type, old_answer_template.data_type, "no"]
          end


        end

      end


    end

    csv_file.close
    map_file.close


  end

  def migrate_survey(survey_slug)
    # First pass:
    # 1. Go through the answers for a given question
    # 2. Find or create the answer session for the given user/survey combo
    # 3. Clone the answer and associated answer values
    # 4. Keep the same answer templates, etc.
    # 5. Only update question id, answer session id
    # 6. Set answer state == :migrated

    ## This should allow all historical values to be saved, without



    survey = Survey.find_by(slug: survey_slug)

    survey.all_questions_descendants.each do |question|
      question.answer_templates.each do |answer_template|
        matched_mapping = @question_map.select{|mapping| (mapping["slug"] == question.slug and mapping["answer_template_name"] == answer_template.name) }.first

        if matched_mapping
          matched_question = Question.find(matched_mapping["id"].to_i)

          matched_question.answers.each do |matched_answer|
            matched_user = matched_answer.answer_session.user
            new_answer_session = matched_user.answer_sessions.find_or_create_by(survey_id: survey.id, encounter: "migrated")

            matched_answer.answer_values.each do |matched_answer_value|
              # Do not create empty answers!
              unless matched_answer_value.show_value.blank?
                new_answer = Answer.find_or_create_by(question_id: question.id, answer_session_id: new_answer_session.id, state: "migrated")

                puts "Migrating answer for #{matched_user.email} | #{question.slug}"
                matched_answer_template = matched_answer_value.answer_template

                if answer_template.data_type == 'answer_option_id' and matched_answer_template.data_type == 'answer_option_id'
                  # Target answer template is categorical and matched answer value is categorical
                  matched_option_id = matched_answer_value.answer_option_id

                  matched_answer_option_mapping = @answer_option_map.select {|mapping| (mapping["old_option_id"] == matched_option_id and mapping["new_template_name"] == answer_template.name)}.first

                  if matched_answer_option_mapping
                    new_answer_option = answer_template.answer_options.find_by_value(matched_answer_option_mapping["new_option_value"])
                    new_answer.answer_values.create(answer_template_id: answer_template.id, answer_option_id: new_answer_option.id)
                    new_answer.save!
                  else
                    puts "Mapping not found! #{matched_option_id} #{answer_template.name}"
                  end

                elsif answer_template.data_type == matched_answer_template.data_type
                  # Match of types - just copy
                  new_answer.answer_values.create(:answer_template_id => answer_template.id, answer_template.data_type => matched_answer_value.value)
                  new_answer.save!
                else
                  puts "Unresolved match! #{matched_mapping["slug"]} | #{matched_mapping["answer_template_name"]} | #{answer_template.data_type}:#{matched_answer_template.data_type}"
                  new_answer.answer_values.create(:answer_template_id => answer_template.id, answer_template.data_type => matched_answer_value.value)
                  new_answer.save!
                end
              end
            end
          end


        end

      end
    end
  end

end