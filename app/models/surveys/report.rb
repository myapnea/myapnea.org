=begin
  Documentation

  # A variable, encounter, and corresponding answer.
  class FilterVariable

  end

  # The Main Class Filter object
  # Contains groups by "user_id", along with numerous FilterVariables for the "user_id"
  class Filter
    attr_accessor :user_objects, :only_locked
    def initialize(only_locked=true)
       # `only_locked` is to require to only pull answers from answer_sessions that are locked
      @only_locked = only_locked
      @user_objects = []
    end

    # Starts building the data. Only data specified is pulled
    def add_data!(survey_slug, variable_slug, encounter='baseline')
    end

    def where(variable_slug, encounter, conditional)
      return self.with rows_removed_base_on_condition()
    end

    def count
      return @user_objects.count
    end

  end




@my_filter = Filter.new(false) # Use all submitted answers, not just locked answers
@my_filter.add_data!('about-me', 'date-of-birth', 'baseline')
@my_filter.add_data('additional-information-about-me','height','baseline')

@my_filter.where('date-of-birth', 'baseline', "in?(45..50)").where('height', 'baseline', ">20").count

=end


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
