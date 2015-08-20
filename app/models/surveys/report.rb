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

  def self.frequency_data(question_slug, values=nil, users=nil)

    q = Question.where(slug: question_slug).includes(answer_templates: :answer_options).first
    answer_options = q.answer_templates.first.answer_options


    base_query = Report.where(question_slug: question_slug)
    base_query = base_query.where(value: values.map(&:to_s)) if values.present?
    base_query = base_query.where(user: users.map(&:to_s)) if users.present?

    total_count = base_query.count

    ao_counts = base_query.select("survey_slug, question_slug, answer_template_name,answer_option_id,value,max(answer_option_text) as answer_option_text,count(answer_value_id) as answer_count").group('survey_slug,question_slug,answer_template_name,value,answer_option_id').map(&:attributes)


    final_counts = answer_options.map do |ao|
      ao_count = ao_counts.select{|ac| ac["answer_option_id"] == ao.id}.first
      ac = ao_count.present? ? ao_count["answer_count"] : 0

      [ao.value, {text: ao.text, count: ac, freq: (ac.to_f/total_count.to_f)*100.0}]
    end

    Hash[final_counts]
    #answer_options

    #final_counts
    #ao_counts
  end

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

  def self.personal_wakeup_time_toclock(user)
    time = Report.where(encounter: 'baseline', question_slug: 'ideal-wakeup', user_id: user.id, value: 1..5).pluck(:value)[0].to_i
    times = [6, 7, 8, 10, 12]
    times[time-1]
  end

  def self.median_wakeup_time()
    values = Report.where(encounter: 'baseline', question_slug: 'ideal-wakeup', locked: true, value: 1..5).select('value,answer_option_text').map{|row| {value: row.value, text: row.answer_option_text}}.sort{|x,y| x[:value] <=> y[:value]}
    values[values.length/2][:text]
  end

  def self.personal_ess(encounter, user_id)
    values = Report.where(encounter: encounter, question_slug: 'epworth-sleepiness-scale', user_id: user_id, locked: true, value: ['0','1','2','3']).pluck(:value)

    if values.length ==  8
      values.map(&:to_i).sum
    else
      nil
    end
  end

  def self.average_ess(encounter)
    values = Report.where(encounter: encounter, question_slug: 'epworth-sleepiness-scale', value: ['0','1','2','3'], locked: true).group(:answer_session_id).having('count(value) = 8').pluck('sum(value::int)')
    values.sum/values.length.to_f
  end

  ## Additional Info About Me
  def self.current_marital_status_data
    table_data = Report.frequency_data('marital-status', 1..6)
    return self.table_to_freq_array(table_data)
  end

  def self.daily_activities_data
    table_data = Report.frequency_data('daily-activities', 1..9)
    return self.table_to_freq_array(table_data)
  end

  def self.affording_basics_data
    table_data = Report.frequency_data('affording-basics', 1..4)
    return self.table_to_freq_array(table_data)
  end

  ## About my family

  def self.family_diagnostic_answer(encounter, user)
    answers = Report.where(encounter: encounter, survey_slug: 'about-my-family', question_slug: 'family-diagnoses', user: user.id, value: %w(1 2 3 4 5 6 7)).where.not(answer_option_text: ["1", "2", "3+"]).pluck(:answer_option_text)
    answers.present? ? answers.collect{|answer| answer.partition(' ').first}.join(', ') : nil
  end

  # def self.country_of_origin_answer(encounter, user)
  #   radio_answer = Report.where(encounter: encounter, survey_slug: 'about-my-family', question_slug: 'origin-country', answer_template_name: 'country_list', user: user.id).first
  #   specific_answer = Report.where(encounter: encounter, survey_slug: 'about-my-family', question_slug: 'origin-country', answer_template_name: 'specified_country', user: user.id).first
  #
  #   if radio_answer.present?
  #     if radio_answer.value.to_i == 7
  #       specific_answer.value if specific_answer.present?
  #     else
  #       radio_answer.answer_option_text
  #     end
  #   else
  #     nil
  #   end
  # end

  def self.country_of_origin
    table_data = self.frequency_data('origin-country', 1..6)
    extra_table_data = self.tabular_data(survey_slug: 'about-my-family', question_slug: 'origin-country', answer_template_name: 'specified_country')
  end

  def self.primary_language_data
    table_data = self.frequency_data('primary-language', 1..3)
    return self.table_to_freq_array(table_data)
  end

  def self.family_diagnostic_data
    table_data = self.frequency_data('family-diagnoses', 1..6)
    return self.table_to_freq_array(table_data)
  end

  ## My Risk Profile

  def self.selected_symptoms(encounter, survey_slug, user)
    answers = Report.where(encounter: encounter, user_id: user.id, question_slug: survey_slug, value: 1..4)
    symptoms = []
    answers.each do |answer|
      unless answer.answer_option_text == "N/A"
        symptoms.push(AnswerTemplate.find_by_id(answer.answer_template_id).text)
      end
    end
    symptoms.empty? ? nil : symptoms
  end

  ## HELPERS
  private
  def self.table_to_freq_array(table)
    array = []
    table.each do |row|
      array.push(row[1][:freq])
    end
    return array
  end

  def self.percent_by_value(encounter, slug, values)
    selected = Report.where(encounter: encounter, question_slug: slug, locked: true, value: values).count
    total = Report.where(encounter: encounter, question_slug: slug, locked: true).count
    (selected / total.to_f) * 100.0
  end

  def self.percentage(count, total)
    (count.to_f/total.to_f) * 100.0
  end
end
