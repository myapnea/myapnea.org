=begin
  am = AnswerMigration.new("lib/data/myapnea/surveys/answer_migration/question_mappings.yml")
  am.validate_question_map
    am.set_answer_option_mappings("/home/pwm4/Desktop")
=end

class AnswerMigration

  def initialize(question_map)
    if question_map.is_a?(Array)
      @question_map = question_map
    else
      @question_map = YAML::load_file(question_map)
    end

    # @unresolved_mappings = []
    # @resolved_mappings = []
    #
    # @matches_found = []
    # @unique_matches = []
    # @unique_matches_not_found = []
    # @matches_not_found = []

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

            map_file.write "\n# #{new_question.slug} : #{old_question.id} \n# #{option_text_list.join(" | ")}\n"

            old_answer_template.answer_options.each do |answer_option|
              matched_option_text = option_matcher.find(answer_option.text_value)
              puts "#{old_question.id} | #{answer_option.id} #{matched_option_text}"
              matched_answer_option = option_list.where(text: matched_option_text).first

              stripped_matched = matched_option_text.strip if matched_option_text
              stripped_text = answer_option.text_value.strip if answer_option.text_value
              same = stripped_matched == stripped_text

              csv_file << [new_question.slug, new_answer_template.name, old_question.id, "categorical", "categorical", "yes", stripped_text, stripped_matched, same] + option_text_list


              map_file.write "- old_option_id: #{answer_option.id} # #{answer_option.text_value.strip}\n"
              map_file.write "  new_option_id: #{matched_answer_option.id if matched_answer_option} # #{matched_option_text.strip if matched_option_text}\n"
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

  def migrate_old_answers(question_map=nil)
    # First pass:
    # 1. Go through the answers for a given question
    # 2. Find or create the answer session for the given user/survey combo
    # 3. Clone the answer and associated answer values
    # 4. Keep the same answer templates, etc.
    # 5. Only update question id, answer session id
    # 6. Set answer state == :migrated

    ## This should allow all historical values to be saved, without


    SURVEY_LIST.each do |slug|
      survey = Survey.find_by(slug: slug)
      survey.all_questions_descendants.each do |question|
        question.answer_templates.each do |answer_template|
          option_list = answer_template.answer_options.map(&:text)
          option_matcher = FuzzyMatch.new(option_list) if answer_template.answer_options.present?

          matched_mapping = question_map.select {|mapping| (mapping["slug"] == question.slug and mapping["answer_template_name"] == answer_template.name) }.first
          if matched_mapping
            matched_question = Question.find(matched_mapping["id"].to_i)

            matched_question.answers.each do |matched_answer|
              matched_user = matched_answer.answer_session.user
              #new_answer_session = matched_user.answer_sessions.find_or_create_by(survey_id: survey.id, encounter: "migrated")

              #new_answer = Answer.new(question_id: question.id, answer_session_id: new_answer_session.id, state: "migrated")



              matched_answer.answer_values.each do |matched_answer_value|
                #puts "#{matched_answer_value.show_value.blank? ? 0 : 1} | #{matched_answer_value.show_value}"
                # Do not create empty answers!
                unless matched_answer_value.show_value.blank?

                  if answer_template.data_type == 'answer_option_id'
                    # Target answer template is categorical
                    if matched_answer_value.answer_template.data_type == "answer_option_id"
                      # Matched answer value is categorical
                      matched_option = option_matcher.find(matched_answer_value.show_value)

                      if matched_option
                        sh = {question: question.slug, answer_template: answer_template.name, old: matched_answer_value.show_value, new: matched_option, list: option_list}
                        matches_found << sh
                        unique_matches << sh unless unique_matches.include?(sh)
                      else
                        sh = {question: question.slug, answer_template: answer_template.name, old: matched_answer_value.show_value, list: option_list}
                        matches_not_found << sh
                        unique_matches_not_found << sh unless unique_matches_not_found.include?(sh)
                      end



                      resolved_mappings << matched_mapping unless resolved_mappings.include?(matched_mapping)
                    else
                      # We need to map non-categorical ==> Categorical
                      #puts "Categorization needed! #{matched_mapping}"
                      unresolved_mappings << matched_mapping unless unresolved_mappings.include?(matched_mapping)
                    end
                  else
                    # Target answer template is non-categorical
                    if answer_template.data_type == matched_answer_value.answer_template.data_type
                      # Match of types - just copy

                      resolved_mappings << matched_mapping unless resolved_mappings.include?(matched_mapping)
                    else
                      # Type mismatch needs to be resolved
                      unresolved_mappings << matched_mapping unless unresolved_mappings.include?(matched_mapping)
                    end
                  end
                end
                #new_answer_value = cloned_answer.answer_values.create(answer_template_id: matched_answer_value.answer_template_id, answer_option_id: matched_answer_value.answer_option_id, numeric_value: matched_answer_value.numeric_value, text_value: matched_answer_value.text_value, time_value: matched_answer_value.time_value)
                #puts "#{new_answer_value.show_value} | #{matched_answer_value.answer_template.answer_options.map(&:text)} "

              end



              #logger.debug cloned_answer.show_value

            end


          end

        end
      end
    end

    File.open("/home/pwm4/Desktop/resolved.yml", 'w') {|f| f.write resolved_mappings.to_yaml }
    File.open("/home/pwm4/Desktop/unresolved.yml", 'w') {|f| f.write unresolved_mappings.to_yaml }
    File.open("/home/pwm4/Desktop/matches_found.yml", 'w') {|f| f.write matches_found.to_yaml }
    File.open("/home/pwm4/Desktop/matches_not_found.yml", 'w') {|f| f.write matches_not_found.to_yaml }
    File.open("/home/pwm4/Desktop/unique_matches_found.yml", 'w') {|f| f.write unique_matches.to_yaml }
    File.open("/home/pwm4/Desktop/unique_matches_not_found.yml", 'w') {|f| f.write unique_matches_not_found.to_yaml }


    {resolved: resolved_mappings, unresolved: unresolved_mappings, found: matches_found, not_found: matches_not_found}
  end


  def categorical_mappings

  end
  
end