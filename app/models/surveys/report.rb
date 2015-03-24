class Report
  # When creating a report, you create it for:
  # - a user (normal, researcher, etc.)
  # - an encounter (list, possibly)
  # - other conditions to be added later?

  # Data should be presented in a way that's most easily graph-able
  ## label, count, total, frequency

  # Some considerations:
  # - survey?
  # - encounter
  # - specific user
  #

  # For now, group functions by survey
  def user

  end


  ## The core is answer value...

  ## Additional Info About Me
  def bmi
    # height/height
    # weight/weight


    AnswerValue.joins(:answer)
    ((weight / (height * height)) * 703)
  end

  def self.current_marital_status
    # slug:
    AnswerSession.current
  end

end