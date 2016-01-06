namespace :surveys do
  desc 'Automatically launch followup encounters for users who have filled out a corresponding baseline survey'
  task launch_followup_encounters: :environment do
    Survey.launch_followup_encounters
  end

  desc 'Add default baseline encounter.'
  task add_baseline_encounter: :environment do
    ActiveRecord::Base.connection.execute('TRUNCATE encounters RESTART IDENTITY')
    owner = User.where(owner: true).first
    baseline = Encounter.create(user_id: owner.id, name: 'Baseline', slug: 'baseline', launch_days_after_sign_up: 0)
    Survey.all.each do |s|
      s.survey_encounters.create(user: s.user, encounter: baseline)
    end
  end

  desc 'Survey updates for Release v9.2.1'
  task release_9_2_1_updates: :environment do
    owner = User.where(owner: true).first

    # Update My Risk Profile survey
    q = Question.find_by_slug 'risk-symptoms'
    q.answer_templates.update_all archived: true
    answer_template_names = [['snoring_risk_symptom_2', 'Snoring'],
                             ['sleepiness_risk_symptom_2', 'Sleepiness'],
                             ['tiredness_risk_symptom_2', 'Tiredness'],
                             ['accident_risk_symptom_2', 'Driving or work accident'],
                             ['shortness_breath_risk_symptom_2', 'Shortness of breath during sleep'],
                             ['stopped_breathing_risk_symptom_2', 'Stopped breathing during sleep'],
                             ['heart_disease_risk_symptom_2', 'Heart disease'],
                             ['hpb_risk_symptom_2', 'High blood pressure'],
                             ['depressed_risk_symptom_2', 'Depressed mood'],
                             ['irritability_risk_symptom_2', 'Irritability'],
                             ['concerned_friend_risk_symptom_2', 'Concerned friend or spouse'],
                             ['forgetfulness_risk_symptom_2', 'Forgetfulness'],
                             ['anxiety_risk_symptom', 'Anxiety disorder']]
    answer_option_names = [['Less than 1 year', 'A', 1],
                           ['1-2 years', 'B', 2],
                           ['3-5 years', 'C', 3],
                           ['6-10 years', 'D', 4],
                           ['11 or more years', 'E', 5],
                           ['I do not experience this symptom', 'F', 6]]
    answer_template_names.each do |at_name, at_text|
      at = q.answer_templates.create(name: at_name, text: at_text, template_name: 'radio', user_id: owner.id)
      answer_option_names.each do |ao_text, ao_hotkey, ao_value|
        at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: 'option-of-multiple option-of-6 label-default', user_id: owner.id)
      end
    end

    # Update My Sleep Apnea survey
    q = Question.find_by_slug 'symptoms-before-diagnosis'
    q.answer_templates.update_all archived: true
    answer_template_names = [['snoring_before_diagnosis_2', 'Snoring'], ['sleepiness_before_diagnosis_2', 'Sleepiness'], ['tiredness_before_diagnosis_2', 'Tiredness'], ['accident_before_diagnosis_2', 'Driving or work accident'], ['shortness_breath_before_diagnosis_2', 'Shortness of breath during sleep'], ['stopped_breathing_before_diagnosis_2', 'Stopped breathing during sleep'], ['heart_disease_before_diagnosis_2', 'Heart disease'], ['hbp_before_diagnosis_2', 'High blood pressure'], ['depressed_before_diagnosis_2', 'Depressed mood'], ['irritability_before_diagnosis_2', 'Irritability'], ['concerned_friend_before_diagnosis_2', 'Concerned friend or spouse'], ['forgetfulness_before_diagnosis_2', 'Forgetfulness'], ['provider_suggestion_before_diagnosis_2', "Healthcare provider's suggestion"], ['anxiety_before_diagnosis', 'Anxiety disorder']]
    answer_option_names = [['Less than 1 year', 'A', 1], ['1-2 years', 'B', 2], ['3-5 years', 'C', 3], ['6-10 years', 'D', 4], ['11 or more years', 'E', 5], ['I did not experience this symptom', 'F', 6]]

    answer_template_names.each do |at_name, at_text|
      at = q.answer_templates.create(name: at_name, text: at_text, template_name: 'radio', user_id: owner.id)
      answer_option_names.each do |ao_text, ao_hotkey, ao_value|
        at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: 'option-of-multiple option-of-6 label-default', user_id: owner.id)
      end
    end

    # Update My Sleep Apnea Treatment
    s = Survey.find_by_slug 'my-sleep-apnea-treatment'
    q = Question.find_by_slug 'treatment-outcomes-components'
    q.answer_templates.update_all archived: true
    q.update archived: true
    q = s.questions.create(slug: 'current-treatment-outcomes-components', text_en: 'How do you think your current sleep apnea treatment has influenced the following?', user_id: owner.id)
    answer_template_names = [['current_treatment_outcome_sleepiness', 'Sleepiness'],
                             ['current_treatment_outcome_sleep_quality', 'Sleep Quality'],
                             ['current_treatment_outcome_energy_level', 'Energy level'],
                             ['current_treatment_outcome_alertness', 'Alertness'],
                             ['current_treatment_outcome_attention', 'Attention']]
    answer_option_names = [['Much worse', '1', 1, 'option-of-multiple option-of-6 survey-scale survey-scale-danger'],
                           ['Mildly worse', '2', 2, 'option-of-multiple option-of-6 survey-scale survey-scale-warning'],
                           ['No change', '3', 3, 'option-of-multiple option-of-6 survey-scale survey-scale-moderate'],
                           ['Mildly better', '4', 4, 'option-of-multiple option-of-6 survey-scale survey-scale-good'],
                           ['Much better', '5', 5, 'option-of-multiple option-of-6 survey-scale survey-scale-great'],
                           ['Prefer not to answer', '6', 6, 'option-of-multiple option-of-6 survey-scale']]

    answer_template_names.each do |at_name, at_text|
      at = q.answer_templates.create(name: at_name, text: at_text, template_name: 'radio', user_id: owner.id)
      answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
        at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
      end
    end

    # Create CPAP Adherence
    s = Survey.create(user_id: owner.id, name_en: 'CPAP Adherence', slug: 'cpap-adherence', description_en: "We are interested in getting some feedback from patients about how much they use their CPAP, and what motivates them to use CPAP.  Our hope is that the responses we receive will help guide us as we think about new ways to support patients as they begin and continue to use CPAP.\r\n\r\nPlease complete this survey if you have ever used CPAP at home (currently, or in the past).  Please note that the word 'CPAP' here refers to CPAP or any similar device including: auto-PAP, flexible pressure, expiratory pressure-relief, and bi-level PAP.\r\n", status: 'show')
    s.survey_user_types.create(user_type: 'adult_diagnosed', user_id: owner.id)

    q = s.questions.create(slug: 'when-were-you-first-prescribed-cpap', text_en: 'When were you first prescribed CPAP?', user_id: owner.id)
    at = q.answer_templates.create(name: 'prescribed-cpap', text: '', template_name: 'radio', user_id: owner.id)
    answer_option_names = [["Less than 1 month ago", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["1 - 6 months ago", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["6 - 12 months ago", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["1 - 5 years ago", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["More than 5 years ago", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end

    q = s.questions.create(slug: 'in-the-past-month-i-used-my-cpap', text_en: 'In the past month, I used my CPAP', user_id: owner.id)
    at = q.answer_templates.create(name: 'used-cpap', text: '', template_name: 'radio', user_id: owner.id)
    answer_option_names = [["7 nights per week", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["5 - 6 nights per week", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["3 - 4 nights per week", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["1 - 2 nights per week", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I have stopped using CPAP", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end

    q = s.questions.create(slug: 'past-month-duration-of-cpap-use', text_en: 'In the past month, when I used my CPAP, I used it for', user_id: owner.id)
    at = q.answer_templates.create(name: 'duration-of-cpap-use', text: '', template_name: 'radio', user_id: owner.id)
    answer_option_names = [["7 hours or more", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["6 hours", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["5 hours", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["4 hours", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["3 hours", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["2 hours", "6", 6, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["1 hour", "7", 7, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Less than 1 hour", "8", 8, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end

    q = s.questions.create(slug: 'typical-night-slept', text_en: 'On a typical night in the past month, I slept', user_id: owner.id)
    at = q.answer_templates.create(name: 'typical-night-slept-duration', text: '', template_name: 'radio', user_id: owner.id)
    answer_option_names = [["7 hours or more", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["6 hours", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["5 hours", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["4 hours", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["3 hours", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Less than 3 hours", "6", 6, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end

    q = s.questions.create(slug: 'cpap-use-changed', text_en: 'How has your use of CPAP changed over time?', user_id: owner.id)
    at = q.answer_templates.create(name: 'cpap-use-changed', text: '', template_name: 'radio', user_id: owner.id)
    answer_option_names = [["About the same amount as my first month of treatment", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Less than in my first month of treatment", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["More than in my first month of treatment", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Use had gone up and down", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end

    q = s.questions.create(slug: 'dont-wake-up-with-cpap', text_en: 'Some people fall asleep with their CPAP mask on, but find that they are no longer wearing it when they wake up. If this happens to you, what are the reason(s)?', user_id: owner.id)
    at = q.answer_templates.create(name: 'dont-wake-up-with-cpap-why', text: '', template_name: 'checkbox', user_id: owner.id)
    answer_option_names = [["This has never happened to me", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["This has happened to me, but I don't know why", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I get out of bed (for example, to go to the bathroom), and don't put my CPAP back on", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I wake up and can't go back to sleep with the mask on", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I enjoy sleeping without my CPAP sometimes", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end

    q = s.questions.create(slug: 'why-do-you-use-cpap', text_en: 'Why do you use CPAP?', user_id: owner.id)
    at = q.answer_templates.create(name: 'reasons-use-cpap', text: '', template_name: 'checkbox', user_id: owner.id)
    answer_option_names = [["Does not apply (I no longer use CPAP)", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I like falling asleep using it", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My sleep is less disrupted", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I feel more refreshed", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I have more engery", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I can concentrate better during the day", "6", 6, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My mood is better", "7", 7, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I get more done during the day", "8", 8, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I have more sexual desire", "9", 9, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I hope to improve my other health problems (e.g. high blood pressure)", "10", 10, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I hope to prevent long-term health problems (e.g. heart attack or stroke)", "11", 11, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I hope to prevent having a car accident", "12", 12, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My partner wants me not to snore", "13", 13, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Family members want me not to snore", "14", 14, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My partner want me to be healthy", "15", 15, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Family members want me to be healthy", "16", 16, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My doctor told me to use CPAP", "17", 17, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I have family/friends that use CPAP with good results", "18", 18, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Other", "19", 19, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end
    at = q.answer_templates.create(name: 'reasons-use-cpap-other', text: '', template_name: 'string', user_id: owner.id, parent_answer_template_id: at.id, parent_answer_option_value: 19)

    q = s.questions.create(slug: 'reasons-dont-use-cpap', text_en: "When you don't use CPAP, what are the reasons?", user_id: owner.id)
    at = q.answer_templates.create(name: 'reasons-dont-use-cpap', text: '', template_name: 'checkbox', user_id: owner.id)
    answer_option_names = [["Does not apply (I always use my CPAP)", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I forget", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I am too tired", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I am too busy", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I am too embarrassed", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I don't know how to use my CPAP", "6", 6, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I felt sick", "7", 7, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I was away from home and forgot my CPAP", "8", 8, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I was away from home, had my CPAP with me, but chose not to use it", "9", 9, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My bed partner is bothered by my CPAP", "10", 10, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Using CPAP makes my sleep worse", "11", 11, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My mask is broken", "12", 12, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My mask is missing parts", "13", 13, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My mask is uncomfortable", "14", 14, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["My mask/machine is noisy", "15", 15, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I have too many other health problems", "16", 16, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I need a break from CPAP", "17", 17, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["I don’t feel that I need to use CPAP", "18", 18, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Other", "19", 19, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end
    at = q.answer_templates.create(name: 'reasons-dont-use-cpap-other', text: '', template_name: 'string', user_id: owner.id, parent_answer_template_id: at.id, parent_answer_option_value: 19)

    q = s.questions.create(slug: 'things-might-have-helped-cpap-use', text_en: 'Thinking back to your first few months of CPAP, which things might have helped you use your CPAP more?', user_id: owner.id)
    at = q.answer_templates.create(name: 'thing-help-cpap-use', text: '', template_name: 'checkbox', user_id: owner.id)
    answer_option_names = [["Does not apply (I could not have used my CPAP more during the first few months)", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Better understanding what sleep apnea is, and how it might affect my health", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Better understanding what CPAP is and how it works", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Better understanding the results of my sleep study", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["A better fitting mask", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["A reward (cash or other incentive)", "6", 6, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Being able to see a daily report of my CPAP usage, mask leaks, etc.", "7", 7, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Getting regular text messages/emails of my CPAP usage, mask leaks, etc.", "8", 8, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["More options of which mask to use", "9", 9, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["More options of which machine to use", "10", 10, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["More time with, or access to, my sleep specialist", "11", 11, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Speaking in person with another CPAP user one-on-one to share advice and information", "12", 12, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Speaking in person with other CPAP users as a group to share advice and information", "13", 13, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Speaking over the phone with another CPAP user to share advice and information", "14", 14, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Using a website/blog to share advice and information with other CPAP users", "15", 15, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Other", "16", 16, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end
    at = q.answer_templates.create(name: 'thing-help-cpap-use-other', text: '', template_name: 'string', user_id: owner.id, parent_answer_template_id: at.id, parent_answer_option_value: 16)

    q = s.questions.create(slug: 'reasonable-fee-cpap', text_en: 'Please consider this hypothetical situation, which might help us understand how much value people place on using CPAP. Suppose your insurance company decides to charge a monthly fee to patients who do not use their CPAP for at least 4 hours per night on average. How much do you think is a reasonable fee to be charged for not using CPAP at least four hours per night?', user_id: owner.id)
    at = q.answer_templates.create(name: 'fee-cpap', text: '', template_name: 'radio', user_id: owner.id)
    answer_option_names = [["I don't think a fee is reasonable", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$10 per month", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$25 per month", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$50 per month", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$100 per month", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Other amount", "6", 6, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end
    at = q.answer_templates.create(name: 'fee-cpap-other', text: '', template_name: 'string', user_id: owner.id, parent_answer_template_id: at.id, parent_answer_option_value: 6)

    q = s.questions.create(slug: 'cpap-reward-4-hours', text_en: 'Please consider this hypothetical situation, which might help us understand how much value people place on using CPAP. Suppose your insurance company decides to offer a cash reward to patients who use their CPAP for at least 4 hours per night on average. How much do you think is a reasonable reward to receive for using CPAP at least 4 hours per night?', user_id: owner.id)
    at = q.answer_templates.create(name: 'cpap-reward', text: '', template_name: 'radio', user_id: owner.id)
    answer_option_names = [["I don't think a reward is reasonable", "1", 1, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$10 per month", "2", 2, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$25 per month", "3", 3, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$50 per month", "4", 4, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["$100 per month", "5", 5, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"], ["Other amount", "6", 6, "option-of-3 option-of-multiple radio-input-container survey-scale survey-scale-blue"]]
    answer_option_names.each do |ao_text, ao_hotkey, ao_value, ao_display_class|
      at.answer_options.create(text: ao_text, hotkey: ao_hotkey, value: ao_value, display_class: ao_display_class, user_id: owner.id)
    end
    at = q.answer_templates.create(name: 'cpap-reward-other', text: '', template_name: 'string', user_id: owner.id, parent_answer_template_id: at.id, parent_answer_option_value: 6)

    q = s.questions.create(slug: 'advice', text_en: 'If you were asked to talk to someone just about to start using CPAP, what advice would you give?', user_id: owner.id)
    at = q.answer_templates.create(name: 'advice', text: '', template_name: 'string', user_id: owner.id)

    # Assign new surveys
    User.find_each(batch_size: 100) do |u|
      u.send(:assign_default_surveys)
    end

    # Unlock surveys that have been updated
    surveys = Survey.where(slug: %w(my-risk-profile my-sleep-apnea my-sleep-apnea-treatment))
    AnswerSession.where(survey_id: surveys.select(:id)).find_each do |as|
      as.unlock!
    end
    questions = Question.where(slug: %w(risk-symptoms symptoms-before-diagnosis))
    Answer.where(question_id: questions.select(:id)).update_all state: 'incomplete'
  end
end
