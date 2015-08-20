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

  ## Additional Info About Me
  def self.compute_bmi(answer_session)
    if answer_session
      weight = self.get_value('weight', answer_session)
      height = self.get_value('height', answer_session)
      bmi = (weight * 703.0 / (height * height) rescue nil)
    else
      nil
    end
  end

  ## My Health Conditions
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

end
