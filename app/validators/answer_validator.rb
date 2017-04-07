# frozen_string_literal: true

class AnswerValidator
  def initialize(question_slug)
    @function_name = "validate_#{question_slug.underscore}"
  end

  def valid?(answer)
    validate(answer)[:valid]
  end

  def messages(answer)
    validate(answer)[:messages]
  end

  def validate(answer)
    if self.respond_to?(@function_name, true)
      self.send(@function_name, answer)
    else
      # If no validation method, return true
      { valid: true, messages: [] }
    end
  end

  private

  def validate_date_of_birth(answer)
    valid = true
    messages = []

    av = answer.answer_values.first

    if av.present? && av.value.present?
      begin
        (month, day, year) = av.value.split('/')

        day = day.to_i
        month = month.to_i
        year = year.to_i

        if year < 1900 || year > Time.zone.today.year
          valid = false
          messages << 'Year is out of range.'
        end

        if month < 1 || month > 12
          valid = false
          messages << 'Month is out of range.'
        end

        max_days = Time.days_in_month(month, year)

        if day < 1 || day > max_days
          valid = false
          messages << 'Day is out of range.'
        end

        date_value = Date.strptime(av.value, '%m/%d/%Y') if valid

      rescue ArgumentError
        valid = false
        messages << 'The date provided is not in the correct format. Please enter date as MM/DD/YYYY'
      end
    else
      valid = false
      messages << 'No answer provided for date of birth question'
    end

    { valid: valid, messages: messages }
  end
end
