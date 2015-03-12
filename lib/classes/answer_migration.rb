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

  def validate_mapping_coverage
    Survey::SURVEY_LIST.each do |survey_slug|
      survey = Survey.find_by_slug(survey_slug)
      if survey
        survey.questions.each do |question|
          question.answer_templates.each do |answer_template|
            found_mapping = @question_map.select{|qm| qm["slug"] == question.slug and qm["answer_template_name"] == answer_template.name }

            if found_mapping.empty?
              puts "The following question/answer template has no old question mapped for migration: #{survey.slug} | #{question.slug} | #{answer_template.name}"
            end

          end

        end
      end
    end
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

  def inspect
    "question_mappings: #{@question_map.length} | answer_option_mappings: #{@answer_option_map.length}"
  end

  def validate_answer_option_map
    validation = true

    @answer_option_map.each do |ao_mapping|
      begin
        old_ao = AnswerOption.find_by_id(ao_mapping["old_option_id"])

        if old_ao.blank?
          raise StandardError unless ao_mapping["old_value_min"] and ao_mapping["old_value_max"]
        end

        new_template = AnswerTemplate.find_by!(name: ao_mapping["new_template_name"])
        new_template.answer_options.find_by!(value: ao_mapping["new_option_value"])

      rescue => e
        puts "#{e.message} | #{ao_mapping["old_option_id"]} | #{ao_mapping["new_template_name"]} | #{ao_mapping["new_option_value"]}"
        validation = false
      end
    end

    validation
  end

  def answer_option_map
    @answer_option_map
  end

  def question_map
    @question_map
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
          option_list = new_answer_template.answer_options
          option_text_list = option_list.map(&:text)

          if old_answer_template.data_type == "answer_option_id"
            # CATEGORICAL - OLD ANSWER

            # Both are categorical - let's try to match up
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

              map_file.write "  new_option_id: #{matched_answer_option.id if matched_answer_option} # #{matched_option_text.strip if matched_option_text}\n"
            end
          else
            map_file.write "\n# #{new_question.slug} : #{old_question.id} : #{new_answer_template.name} \n# #{option_list.map{|o| "#{o.value} : #{o.text}"}.join(" | ")}\n"
            # Set up for categorical mapping:
            new_answer_template.answer_options.each do |answer_option|
              map_file.write "- old_value_min: \n"
              map_file.write "  old_value_max: \n"
              map_file.write "  new_template_name: #{new_answer_template.name} \n"
              map_file.write "  new_option_value: #{answer_option.value} # #{answer_option.text}\n"

            end


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

  def unlock_incomplete_multiple_radio_answers(survey_slug, user_email=nil, log_file_path=File.join(Rails.root, "tmp", "answer_migration.log"))
    log_file = File.open(log_file_path, "w")

    survey = Survey.find_by(slug: survey_slug)

    survey.questions.where(display_type: "radio_input_multiple").each do |question|
      template_count = question.answer_templates.count

      answers_to_check = question.answers.locked
      answers_to_check = answers_to_check.joins(:answer_session).where(answer_sessions: {user_id: User.find_by_email(user_email).id}) if user_email

      answers_to_check.each do |answer|
        if answer.answer_values.count < template_count
          msg = "Unlocking #{'%15.15s' % question.slug} for #{'%15.15s' % answer.answer_session.user.email}: Had #{answer.answer_values.count.to_s.rjust(3)} of #{template_count.to_s.rjust(3)}"
          puts msg
          log_file.puts(msg)

          # Unlock Answer and Answer Session
          answer.update(state: "incomplete")
          answer.answer_session.update(locked: false)
        end
      end
    end
  end

  def migrate_survey(survey_slug, opts={} )
    # Defaults
    opts = {
        user_email: nil,
        overwrite: false,
        log_file_path: File.join(Rails.root, "tmp", "answer_migration.log"),
        old_question_ids: nil
    }.merge(opts)

    # First pass:
    # 1. Go through the answers for a given question
    # 2. Find or create the answer session for the given user/survey combo
    # 3. Clone the answer and associated answer values
    # 4. Keep the same answer templates, etc.
    # 5. Only update question id, answer session id
    # 6. Set answer state == :migrated

    ## This should allow all historical values to be saved, without

    log_file = File.open(opts[:log_file_path], "w")

    survey = Survey.find_by(slug: survey_slug)

    total_new_question_number = survey.questions.count

    survey.questions.each_with_index do |question, question_i|

      question.answer_templates.each do |answer_template|
        # Get the mapping for the current question and answer template
        matched_mapping = @question_map.select do |mapping|
          matches = (mapping["slug"] == question.slug and mapping["answer_template_name"] == answer_template.name)

          # Limit matchings by question id list
          if opts[:old_question_ids].present?
            matches = (matches and (opts[:old_question_ids].include?(mapping["id"].to_i)))
          end

          matches
        end.first

        if matched_mapping
          # Find matched old question
          matched_question = Question.find(matched_mapping["id"].to_i)

          total_matched_answer_number = matched_question.answers.count

          # Get all answers that need to be migrated, ordering them to get most recent first.
          # If overwrite is set, order them to get most recent last
          answers_to_migrate = matched_question.answers.joins(:answer_session).order("answer_sessions.user_id, answer_sessions.created_at #{opts[:overwrite] ? "asc" : "desc"}")
          answers_to_migrate = answers_to_migrate.where("answer_sessions.user_id = ?", User.find_by_email(opts[:user_email]).id) if opts[:user_email].present?

          answers_to_migrate.each_with_index do |matched_answer, answer_i|
            matched_user = matched_answer.answer_session.user

            # Either create or find answer session for new answer
            new_answer_session = matched_user.answer_sessions.find_or_create_by(survey_id: survey.id, encounter: "baseline")

            # Deal with each answer value sequentially
            ## TODO: multiple answer values that need to be converted to a single one (feet/inches, years/months, )

            # We only want to migrate existing answers, not empty answers
            # If more than one answer value exists, either we have to merge them into one (years/months ==> months, feet/inches ==> inches),
            # or migrate all of them (checkbox inputs)
            matched_answer_value = preprocess_answer_values(matched_question, matched_answer)

            #matched_answer.answer_values.each do |matched_answer_value|
            if matched_answer_value
              # Prevent answers from getting over-written
              new_answer = Answer.find_or_initialize_by(question_id: question.id, answer_session_id: new_answer_session.id, deleted: false)

              ## No answer exists ==> initialized ==> allow
              ## Answer exists, but does not have answer value for given answer template ==> allow
              ## Answer exists, and answer value for given answer template exists ==> skip
              allow_creation = (new_answer.new_record? or
                                (new_answer.persisted? and new_answer.answer_values.where(answer_template_id: answer_template.id).empty?) or
                                opts[:overwrite])

              # Do not create empty answers!
              if allow_creation

                ## OVERWRITE
                if opts[:overwrite]
                  msg = "Overwriting: #{question.slug}/#{answer_template.name} | #{matched_user.email}"
                  log_file.puts msg

                  new_answer.answer_values.where(answer_template_id: answer_template.id).delete_all
                end

                # Lock answer, since we're definitely adding a valid value
                new_answer.update(state: "locked")
                matched_answer_template = matched_answer_value[:answer_template]

                puts "Survey: #{'%-12.12s' % survey.slug} | Question #{(question_i + 1).to_s.rjust(2)} of #{total_new_question_number.to_s.rjust(2)} | Migrating answer #{(answer_i+1).to_s.rjust(5)} of #{total_matched_answer_number.to_s.rjust(5)} for #{'%15.15s' % matched_user.email} | #{'%15.15s' % question.slug}/#{'%15.15s' % answer_template.name} | value: #{matched_answer_value[:value].to_s.rjust(7)} | old_survey: #{matched_answer.answer_session.survey_id.to_s.rjust(2)}"



                if answer_template.data_type == 'answer_option_id' and matched_answer_template.data_type == 'answer_option_id'
                  # Target answer template is categorical and matched answer value is categorical

                  # Deal with multiple answer option ids (checkbox answers)
                  matched_option_ids = matched_answer_value[:answer_option_ids]
                  raise StandardError, "Multiple answer option ids not allowed!" if (matched_option_ids.length > 1 and !answer_template.allow_multiple)

                  matched_option_ids.each do |matched_option_id|
                    matched_answer_option_mapping = @answer_option_map.select {|mapping| (mapping["old_option_id"] == matched_option_id and mapping["new_template_name"] == answer_template.name)}.first

                    if matched_answer_option_mapping
                      new_answer_option = answer_template.answer_options.find_by_value(matched_answer_option_mapping["new_option_value"])
                      new_answer.answer_values.create(answer_template_id: answer_template.id, answer_option_id: new_answer_option.id)
                      new_answer.save!
                    else
                      msg = "Mapping not found! #{matched_option_id} #{answer_template.name}"
                      puts msg
                      log_file.puts msg
                    end
                  end

                elsif answer_template.data_type == matched_answer_template.data_type
                  # Match of types - just copy
                  new_answer.answer_values.create(:answer_template_id => answer_template.id, answer_template.data_type => matched_answer_value[:value])
                  new_answer.save!
                elsif answer_template.data_type == 'answer_option_id' and matched_answer_template.data_type == 'numeric_value'
                  matched_answer_option_mapping = @answer_option_map.select do |mapping|
                    if mapping["new_template_name"] == answer_template.name
                      min = mapping["old_value_min"].to_f
                      max = (numeric?(mapping["old_value_max"]) ? mapping["old_value_max"].to_f : Float.const_get(mapping["old_value_max"]))
                      (matched_answer_value[:value].to_f >= min and matched_answer_value[:value].to_f < max)
                    else
                      false
                    end

                  end.first

                  if matched_answer_option_mapping
                    new_answer_option = answer_template.answer_options.find_by_value(matched_answer_option_mapping["new_option_value"])
                    new_answer.answer_values.create(answer_template_id: answer_template.id, answer_option_id: new_answer_option.id)
                    new_answer.save!
                  else
                    msg = "Blank Answer! #{answer_template.name} | #{matched_answer_value[:value]}"
                    log_file.puts msg
                  end
                elsif answer_template.data_type == 'text_value' and matched_answer_template.data_type == "time_value"
                  # Copy old time values as text
                  new_answer.answer_values.create(:answer_template_id => answer_template.id, answer_template.data_type => matched_answer_value[:value].strftime("%m/%d/%y"))
                  new_answer.save!
                else
                  msg = "Unresolved match! #{matched_mapping["slug"]} | #{matched_mapping["answer_template_name"]} | #{answer_template.data_type}:#{matched_answer_template.data_type}"
                  puts msg
                  log_file.puts msg
                end
              else
                log_file.puts "!Survey: #{survey.slug} | Question #{question_i + 1} of #{total_new_question_number} | ! answer #{answer_i} of #{total_matched_answer_number} for #{matched_user.email} | #{question.slug}/#{answer_template.name} | Empty or present! value: #{matched_answer_value.show_value} | old_as: #{matched_answer.answer_session.survey_id} | count: #{Answer.where(question_id: question.id, answer_session_id: new_answer_session.id).count}"
              end
            end
          end


        end

      end
    end
    log_file.close
  end

  private

  def numeric?(str)
    Float(str) != nil rescue false
  end


  def preprocess_answer_values(question, answer)
    # returns hash with:
    #   - answer_option_ids: array of (usually 1) answer_option_id
    #   - value: raw value, or converted value (for some questions)
    #   - answer_template: unprocessed answer template, or if multiple then first answer template
    answer_option_ids = []
    value = nil

    all_answer_templates = question.answer_templates

    if all_answer_templates.count > 1
      raise StandardError, "Not enough answer values! #{question.id} | #{answer.id}" if (answer.answer_values.count < all_answer_templates.count)

      answer_template = all_answer_templates.first
      answer_template_names = all_answer_templates.map(&:name).sort
      answer_values = answer.answer_values.select{|av| av.show_value.present?}

      if answer_values.present?
        if answer_template_names == ["number_of_months", "number_of_years"]
          # years/months
          month_value = answer_values.select{|av| av.answer_template.name == 'number_of_months'}.first
          year_value = answer_values.select{|av| av.answer_template.name == 'number_of_years'}.first

          months = (month_value.present? ? month_value.value : 0)
          years = (year_value.present? ? year_value.value : 0)

          value = (years * 12) + months
        elsif answer_template_names == ["number_of_feet", "number_of_inches"]
          # feet/inches
          feet_value = answer_values.select{|av| av.answer_template.name == 'number_of_feet'}.first
          inch_value = answer_values.select{|av| av.answer_template.name == 'number_of_inches'}.first

          feet = (feet_value.present? ? feet_value.value : 0)
          inches = (inch_value.present? ? inch_value.value : 0)

          value = (feet*12) + inches
        else
          raise StandardError, "Unaccounted-for multiple answer templates: #{answer_template_names}"
        end
      end
    else
      answer_template = all_answer_templates.first
      answer_values = answer.answer_values.select{|av| av.show_value.present?}

      if answer_values.present?
        if answer_template.allow_multiple
          answer_option_ids = answer_values.map(&:answer_option_id)
        elsif answer_values.length == 1
          answer_value = answer_values.first

          answer_option_ids = [answer_value.answer_option_id] if answer_value.answer_option_id
          value = answer_value.value
        else
          raise StandardError, "Multiple answer values are not allowed! #{question.id} | #{answer.id}"
        end
      else
      end
    end

    if !answer_option_ids.empty? or value
      {
          answer_option_ids: answer_option_ids,
          value: value,
          answer_template: answer_template
      }
    else
      nil
    end


  end
end
