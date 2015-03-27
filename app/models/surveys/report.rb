class Report

  attr_reader :survey, :user, :encounter
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

  def initialize(survey, user, encounter)
    @survey = survey
    @user = user
    @encounter = encounter
  end


  def report_data(section)

  end


  ## Accessor


  ## Custom Report Methods: return tabular data
  ## Naming convention: <survey slug>_<section>

  def about_me_sex
    SurveyAnswerFrequency.find_by
  end

  def about_me_race

  end

  def about_me_hispanic

  end

  def about_me_education

  end

  def about_me_income

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
