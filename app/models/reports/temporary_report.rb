class TemporaryReport

  def self.answer_option_counts(survey, question, answer_template, encounter: nil, range: nil)
    if question
      answer_value_scope = question.community_answer_values(encounter, answer_template).joins(:answer_option)
      answer_value_scope = answer_value_scope.where(answer_options: { value: range }) if range
      answer_value_scope
    else
      AnswerValue.joins(:answer_option).none
    end.group(:answer_option).count
  end

  # Additional Info About Me
  def self.compute_bmi(answer_session)
    if answer_session
      weight = self.get_value('weight', answer_session)
      height = self.get_value('height', answer_session)
      bmi = (weight * 703.0 / (height * height) rescue nil)
    else
      nil
    end
  end

  # My Health Conditions
  def self.health_conditions(survey, encounter)
    result = { nodes: [], links: [] }
    if encounter and question = survey.questions.find_by_slug('health-conditions-list')
      question.answer_templates.each do |answer_template|
        answer_option_counts = self.answer_option_counts(survey, question, answer_template, encounter: encounter, range: 1..2)
        ri = ReportItem.new(answer_option_counts, answer_template, 1)
        result[:nodes] << { name: answer_template.text, id: answer_template.name, frequency: ri.percent_number }
        result[:links] << { source: answer_template.name, target: 'conditions-sleep-apnea' }
      end
      result[:nodes] << { name: 'Sleep Apnea', id: 'conditions-sleep-apnea', frequency: 100.0 }
    end
    result
  end

  # My Sleep Quality
  def self.compute_promis_score(answer_session)
    if answer_session
      sleep_quality = self.get_value('sleep-quality-week', answer_session)
      sleep_quality_components = self.get_values('sleep-quality-week-components', answer_session)
      all_values = [sleep_quality] + sleep_quality_components
      answer_options = AnswerOption.where(id: all_values, value: 1..5)
      if answer_options.count == 8
        10*(answer_options.pluck(:value).sum-20)/5.6872 + 50
      else
        nil
      end
    else
      nil
    end
  end

  # My Quality of Life
  def self.quality_of_life_scale(survey, encounter, question_slug)
    range = 1..5
    question = survey.questions.find_by_slug(question_slug)
    answer_template = question.first_radio_or_checkbox_answer_template if question
    answer_option_counts = TemporaryReport.answer_option_counts(survey, question, answer_template, encounter: encounter, range: range)
    range.collect do |answer_option_value|
      report_item = ReportItem.new(answer_option_counts, answer_template, answer_option_value)
      report_item.percent_number
    end
  end

  # My Risk Profile
  def self.risk_symptoms(answer_session, question_slug)
    if answer_session
      my_risk_symptoms = self.get_values(question_slug, answer_session)
      answer_options = AnswerOption.where(id: my_risk_symptoms, value: 1..4)
    else
      AnswerOption.none
    end
  end

  # My Sleep Apnea
  def self.satistification_percent_by_study(survey, study_value, encounter: nil)
    satisfaction = survey.questions.find_by_slug('sleep-study-satisfaction')
    study = survey.questions.find_by_slug('diagnostic-study')

    base_answer_sessions = AnswerSession.current.where(locked: true, encounter: (encounter ? encounter.slug : nil), survey_id: survey.id)
    base_answer_sessions = base_answer_sessions.joins(:user).merge(User.where(include_in_exports: true))

    answer_sessions = base_answer_sessions.joins(:answers).where(answers: { question_id: study.id })
    answer_sessions = answer_sessions.joins(answers: { answer_values: :answer_option }).merge(AnswerOption.where(value: study_value))
    ids_in_study = answer_sessions.pluck(:id).uniq

    answer_sessions = base_answer_sessions.joins(:answers).where(answers: { question_id: satisfaction.id }, id: ids_in_study)
    answer_sessions = answer_sessions.joins(answers: { answer_values: :answer_option }).merge(AnswerOption.where(value: [5..7]))
    ids_satistified = answer_sessions.pluck(:id).uniq

    study_count = ids_in_study.count
    satisfied_count = ids_satistified.count

    percent = if study_count == 0
      0.0
    else
      satisfied_count * 100.0 / study_count
    end
    "#{percent.round(1)}%"
  end

  # My Sleep Apnea Treatment
  def self.treatment_popularity(survey, question, answer_option_value, encounter: nil)
    current_to_satisfaction_map = {
      2 => 'satisfaction_with_cpap',
      3 => 'satisfaction_with_apap',
      4 => 'satisfaction_with_bipap',
      5 => 'satisfaction_with_asv',
      6 => 'satisfaction_with_oral_appliance',
      7 => 'satisfaction_with_behavioral_therapy',
      8 => 'satisfaction_with_tongue_stimulation',
      9 => 'satisfaction_with_tonsillectomy',
      10 => 'satisfaction_with_uppp',
      11 => 'satisfaction_with_naval_deviation',
      12 => 'satisfaction_with_tongue_surgery',
      13 => 'satisfaction_with_jaw_surgery',
      14 => 'satisfaction_with_bariatric_surgery'
    }

    answer_template = question.answer_templates.find_by_name(current_to_satisfaction_map[answer_option_value])
    answer_option_counts = TemporaryReport.answer_option_counts(survey, question, answer_template, encounter: encounter, range: 1..6)
    percent_use_at_some_point = 0
    (1..4).each do |aov|
      ri = ReportItem.new(answer_option_counts, answer_template, aov)
      percent_use_at_some_point = percent_use_at_some_point + ri.percent_number
    end

    answer_option_counts = TemporaryReport.answer_option_counts(survey, question, answer_template, encounter: encounter, range: 1..4)
    ri3 = ReportItem.new(answer_option_counts, answer_template, 3)
    ri4 = ReportItem.new(answer_option_counts, answer_template, 4)

    [percent_use_at_some_point, ri3.percent_number + ri4.percent_number]
  end


  # General single value returned
  def self.get_value(question_slug, answer_session)
    if answer_session and question = answer_session.survey.questions.find_by_slug(question_slug)
      answer_template = question.answer_templates.first
      answer_value = answer_session.answer_values(question, answer_template).first
      answer_value.value if answer_value
    else
      nil
    end
  end

  def self.get_values(question_slug, answer_session)
    if answer_session and question = answer_session.survey.questions.find_by_slug(question_slug)
      AnswerValue.joins(:answer).where(answers: { answer_session_id: answer_session.id, question_id: question.id }).where(answer_template_id: question.answer_templates.select(:id)).collect(&:value)
    else
      []
    end
  end

  def self.get_median_report_item(survey, question, answer_template, encounter: nil, range: nil)
    answer_option_counts = TemporaryReport.answer_option_counts(survey, question, answer_template, encounter: encounter, range: range)
    median = nil
    total = 0
    (range || []).each do |answer_option_value|
      ri = ReportItem.new(answer_option_counts, answer_template, answer_option_value)
      total = total + ri.percent_number
      if total >= 50
        median = ri
        break
      end
    end
    median
  end

end
