class ReportItem

  attr_accessor :answer_option, :count, :total_count, :percent, :percent_number

  def initialize(answer_options_hash, answer_template, value)
    # answer_option_ids = answer_options_hash.collect{|ao, count| ao.id}
    # @total_count = AnswerSession.current.joins(answers: :answer_values).where(answer_values: { answer_template_id: (answer_template ? answer_template.id : nil), answer_option_id: answer_option_ids }, encounter: encounter).distinct.count
    @total_count = answer_options_hash.collect{|ao, count| count}.sum
    (@answer_option, @count) = answer_options_hash.select{|ao, count| ao.value == value}.collect{|ao, count| [ao, count]}.first
    set_percent
    set_answer_option(answer_template, value) unless @answer_option
  end

  def text_and_percent
    "#{@answer_option.text if @answer_option}: #{@percent}"
  end

  def only_percent
    @percent_number
  end

  private

  def set_percent
    @percent_number = if @total_count == 0
      0.0
    else
      ((@count * 100.0 / @total_count) rescue 0.0)
    end
    @percent = "#{@percent_number.round(1)}%"
  end

  def set_answer_option(answer_template, value)
    @answer_option = answer_template.answer_options.find_by_value(value) if answer_template
  end
end
