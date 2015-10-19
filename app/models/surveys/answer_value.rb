class AnswerValue < ActiveRecord::Base
  belongs_to :answer
  belongs_to :answer_option
  belongs_to :answer_template

  include DateAndTimeParser

  def value
    self[answer_template.data_type]
  end

  def string_value
    value.to_s
  end

  def show_value
    if answer_template.data_type == 'answer_option_id'
      answer_option ? answer_option.to_s : nil
    else
      value
    end
  end

  def raw_value
    if answer_template.data_type == 'answer_option_id'
      answer_option ? answer_option.value : nil
    else
      if answer_template.template_name == 'date'
        date = parse_date(text_value)
        date ? date.strftime('%Y-%m-%d') : nil
      else
        value
      end
    end
  end
end
