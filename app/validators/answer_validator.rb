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
      {valid: true, messages: []}
    end

  end

  private

  def validate_date_of_birth(answer)
    valid = true
    messages = []

    av = answer.answer_values.first

    if av.present? and av.value.present?
      begin
        matched_date = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.match(av.value)

        if matched_date
          day = matched_date[2].to_i
          month = matched_date[1].to_i
          year = matched_date[3].to_i

          if year < 1900 or year > 2015
            valid = false
            messages << "Year is out of range."
          end

          if month < 1 or month > 12
            valid = false
            messages << "Month is out of range."
          end

          max_days = Time.days_in_month(month, year)

          if day < 1 or day > max_days
            valid = false
            messages << "Day is out of range."
          end

          if valid

            date_value = Date.strptime(av.value, "%m/%d/%Y")

            difference_in_years = year_diff(Date.today, date_value)
            if difference_in_years < 18
              valid = false
              messages << "You must be over 18 to answer this question"
            end
          end

        else
          valid = false
          messages << "The date provided is not in the correct format. Please enter date as MM/DD/YYYY"
        end



      rescue ArgumentError => e
        valid = false


        messages << "The date provided is not in the correct format. Please enter date as MM/DD/YYYY"

      end
    else
      valid = false
      messages << "No answer provider for date of birth question"
    end

    {valid: valid, messages: messages}
  end

  # Helpers

  def year_diff(d2, d1)
    (d2.year - d1.year) + (d2.month - d1.month - (d2.day >= d1.day ? 0 : 1))/12

  end


end