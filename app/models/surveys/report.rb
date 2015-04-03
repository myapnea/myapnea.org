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


# Columns to filter or group on:
# - created_at
# - updated_at
# - survey_slug
# - question_slug
# - answer_template_name
# - encounter
# - question_state
# - locked
# - preferred_not_to_answer

# Foreign keys (also can be filtered/grouped on)
# - answer_value_id
# - answer_option_id
# - answer_template_id
# - answer_id
# - question_id
# - answer_session_id
# - user_id
# - survey_id

# Columns to read or aggregate:
# - value
# - answer_option_text

class Report < ActiveRecord::Base
  belongs_to :answer_value
  belongs_to :answer_option
  belongs_to :answer_template
  belongs_to :answer
  belongs_to :question
  belongs_to :answer_session
  belongs_to :user
  belongs_to :survey

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


  def self.tabular_data(where_clause, not_where_clause={answer_value_id: nil})
    # survey_slug, question_slug, answer_template_name, encounter, value, answer_option_text, answer_count, total_count, frequency
    q_result = self
        .where(where_clause)
        .where.not(not_where_clause)
        .group('survey_slug, question_slug, answer_template_name, encounter,value')
        .select("survey_slug, question_slug, answer_template_name,encounter,value,max(answer_option_text) as answer_option_text,count(answer_value_id) as answer_count")
        .to_a
    total_count = q_result.map(&:answer_count).sum
    tabbed_data = q_result.map do |q_res|
      h = q_res.attributes
      h["total_count"] = total_count
      h["frequency"] = (h["answer_count"].to_f / total_count.to_f) * 100.0
      [h["value"], h]
    end

    Hash[tabbed_data]
  end





  ## Custom Report Methods: return tabular data
  ## Naming convention: <survey slug>_<section>

  def self.about_me_sex
    self.tabular_data(survey_slug: 'about-me', question_slug: 'sex', answer_template_name: 'sex')
  end

  def about_me_race
    #self.tabular_data({survey_slug: 'about-me', question_slug: 'race', answer_template_name: ['race', 'specified_race']}, {value: '6'})
    self.tabular_data({survey_slug: 'about-me', question_slug: 'race', answer_template_name: 'race'})
  end

  def about_me_hispanic
    self.tabular_data(survey_slug: 'about-me', question_slug: 'ethnicity', answer_template_name: 'ethnicity')
  end

  def about_me_education
    self.tabular_data(survey_slug: 'about-me', question_slug: 'education-level', answer_template_name: 'education_level')
  end

  def about_me_income
    self.tabular_data(survey_slug: 'about-me', question_slug: 'income-level', answer_template_name: 'income_level')
  end



  # My Sleep Pattern
  def self.percent_below_minimum_sleep_weekday()
    percent_by_value('baseline', 'sleep-hours-weekdays', ['1', '2'])
  end

  def self.percent_different_sleep_weekends_weekdays()
    all = Report.where(encounter: 'baseline', question_slug: ['sleep-hours-weekends', 'sleep-hours-weekdays'], locked: true).group('answer_session_id').select('answer_session_id,array_agg(value) as values')
    total_count = all.length


    different_count = all.select{|row| row['values'].uniq.length != 1 }.length


    (different_count / total_count.to_f) * 100.0
  end

  def self.median_wakeup_time()
    values = Report.where(encounter: 'baseline', question_slug: 'ideal-wakeup', locked: true, value: 1..5).select('value,answer_option_text').map{|row| {value: row.value, text: row.answer_option_text}}.sort{|x,y| x[:value] <=> y[:value]}
    values[values.length/2][:text]
  end

  def self.personal_ess(encounter, user_id)
    ess_map = {'4' => 0, '3' => 1, '2' => 2, '1' => 3}

    values = Report.where(encounter: encounter, question_slug: 'epworth-sleepiness-scale', user_id: user_id).pluck(:value)

    values.map{|v| ess_map[v]}.sum

  end

  def self.average_ess(encounter)
    ess_map = {'4' => 0, '3' => 1, '2' => 2, '1' => 3}

    values = Report.where(encounter: encounter, question_slug: 'epworth-sleepiness-scale', value: ['1','2','3','4']).group(:answer_session_id).select("answer_session_id,array_agg(value)")

    values = values.map{|x| x["array_agg"].map{|s| ess_map[s]}.sum}

    values.sum/values.length.to_f
  end

  # My Sleep Quality
  def self.average_promis_score(encounter)
    db_values = Report.where(encounter: encounter, survey_slug: 'my-sleep-quality', value: %w(1 2 3 4 5)).group("answer_session_id").pluck("array_agg(value::int)")
    raw_values = db_values.map(&:sum)

    avg_raw_val = raw_values.sum/raw_values.length

    score = 10*(avg_raw_val-20)/5.6872 + 50

    score
  end

  def self.personal_promis_score(encounter, user)
    raw_value = Report.where(encounter: encounter, survey_slug: 'my-sleep-quality', value: %w(1 2 3 4 5), user_id: user.id).group("answer_session_id").pluck("array_agg(value::int)").first.sum

    10*(raw_value-20)/5.6872 + 50

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


  ## HELPERS
  private

  def self.percent_by_value(encounter, slug, values)
    selected = Report.where(encounter: encounter, question_slug: slug, locked: true, value: values).count
    total = Report.where(encounter: encounter, question_slug: slug, locked: true).count
    (selected / total.to_f) * 100.0
  end
end
