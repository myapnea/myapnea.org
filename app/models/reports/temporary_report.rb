class TemporaryReport

  def self.answer_option_counts(survey, question, answer_template, encounter: nil, range: nil)
    if question
      question.community_answer_values(encounter, answer_template).joins(:answer_option).where(answer_options: { value: range })
    else
      AnswerValue.joins(:answer_option).none
    end.group(:answer_option).count
  end

end
