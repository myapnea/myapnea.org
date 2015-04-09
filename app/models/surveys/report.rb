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

  def self.frequency_data(question_slug, values)
    q = Question.where(slug: question_slug).includes(answer_templates: :answer_options).first
    answer_options = q.answer_templates.first.answer_options


    base_query = Report.where(question_slug: question_slug, value: values.map(&:to_s))
    total_count = base_query.count

    ao_counts = base_query.select("survey_slug, question_slug, answer_template_name,answer_option_id,value,max(answer_option_text) as answer_option_text,count(answer_value_id) as answer_count").group('survey_slug,question_slug,answer_template_name,encounter,value,answer_option_id').map(&:attributes)


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

    values = Report.where(encounter: encounter, question_slug: 'epworth-sleepiness-scale', user_id: user_id, locked: true).pluck(:value)

    values.map{|v| ess_map[v]}.sum

  end

  def self.average_ess(encounter)
    ess_map = {'4' => 0, '3' => 1, '2' => 2, '1' => 3}

    values = Report.where(encounter: encounter, question_slug: 'epworth-sleepiness-scale', value: ['1','2','3','4'], locked: true).group(:answer_session_id).select("answer_session_id,array_agg(value)")

    values = values.map{|x| x["array_agg"].map{|s| ess_map[s]}.sum}

    values.sum/values.length.to_f
  end

  # My Sleep Quality
  def self.average_promis_score(encounter)
    db_values = Report.where(encounter: encounter, survey_slug: 'my-sleep-quality', value: %w(1 2 3 4 5), locked: true).group("answer_session_id").pluck("array_agg(value::int)")
    raw_values = db_values.map(&:sum)

    avg_raw_val = raw_values.sum/raw_values.length

    score = 10*(avg_raw_val-20)/5.6872 + 50

    score
  end

  def self.personal_promis_score(encounter, user)
    raw_value = Report.where(encounter: encounter, survey_slug: 'my-sleep-quality', value: %w(1 2 3 4 5), user_id: user.id).group("answer_session_id").pluck("array_agg(value::int)").first.sum

    10*(raw_value-20)/5.6872 + 50

  end

  # My Sleep Apnea Treatment
  def self.current_treatment_popularity(encounter)

    base_query = Report.where(question_slug: 'types-of-treatments', encounter: encounter, locked: true)
    total_people = base_query.group(:answer_session_id).pluck(:answer_session_id).count

    by_treatment = base_query.where(value: (2..14).map(&:to_s)).group(:value,:answer_option_text).select('value,answer_option_text,count(answer_value_id)').map(&:attributes).sort{|a,b| b["count"]<=>a["count"]}

    by_treatment.each {|t| t['frequency'] = t['count'].to_f/total_people*100.0}

    by_treatment
  end

  def self.treatment_stats(encounter, value)
    current_to_satisfaction_map = {
        2 => 'satisfaction_with_cpap',
        3 => 'satisfaction_with_apap',
        4 => 'satisfaction_with_bipap',
        5 => 'satisfaction_with_asv',
        6 => 'satisfaction_with_oral_appliance',
        7 => 'satisfaction_with_behavioral_therapy',
        8 => 'satisfaction_with_tongue_stimulation',
        9 => 'satisfaction_with_tonsillectomy',
        10 => 'satisfaction_with_uppp',
        11 => 'satisfaction_with_nasal_deviation_surgery',
        12 => 'satisfaction_with_toungue_surgery',
        13 => 'satisfaction_with_jaw_surgery',
        14 => 'satisfaction_with_bariatric_surgery'
    }

    template_name = current_to_satisfaction_map[value]
    # For each treatment (or top 5?) we want all the answer sessions where people indicated a not-6 for that answer_template (satisfaction)
    # Now, for this set of people, we want to find ratings for how the treatment helpled.

    # so, let's do it for CPAP

    base_query = Report.where(answer_template_name: template_name, encounter: encounter, locked: true)
      values = base_query.where.not(value: nil).pluck(:value)
    satisfaction_percent = values.select{|v| %(3 4).include?(v)}.length.to_f/values.length * 100.0
    used_treatment = base_query.where.not(value: ['5', '6']).pluck(:answer_session_id)
    used_treatment_percent = (used_treatment.length.to_f/base_query.count.to_f) * 100.0
    outcomes = Report.where(answer_session_id: used_treatment, question_slug: 'treatment-outcomes-components', value: 1..5).group(:answer_template_name, :answer_template_text).select('answer_template_name,answer_template_text,sum(value::int)').map(&:attributes).sort{|a,b| b['sum']<=>a['sum']}

    helped_most = (outcomes.present? ? outcomes.first["answer_template_text"] : nil)
    helped_least = (outcomes.present? ? outcomes.last["answer_template_text"] : nil)




    {satisfaction: satisfaction_percent, used_treatment: used_treatment_percent, helped_most: helped_most, helped_least: helped_least}
  end


  # My Sleep Apnea

  def self.median_age_of_diagnosis(encounter)
    values = Report.where(encounter: encounter, question_slug: 'age-of-diagnosis', locked: true, value: 1..7).select('value,answer_option_text').map{|row| {value: row.value, text: row.answer_option_text}}.sort{|x,y| x[:value] <=> y[:value]}
    values[values.length/2][:text]
  end

  def self.percent_length_before_diagnosis(encounter)
    base_query = Report.where(encounter: encounter, question_slug: 'apnea-before-diagnosis', locked: true)
    more_than_two_years = base_query.where(value: '6')

    percentage(more_than_two_years.count, base_query.count)

  end

  def self.symptoms_before_diagnosis
    base_query = Report.where(question_slug: 'symptoms-before-diagnosis', locked: true)


    # number !N/A vs. all

    # Median length

    by_symptom = base_query.group(:answer_template_name,:answer_template_text).select("answer_template_name,answer_template_text,count(answer_value_id) as total,array_agg(value) as values, array_agg(answer_option_text) as texts").map(&:attributes)

    by_symptom = by_symptom.map do |symp|
      zipped_values = symp["values"].map(&:to_i).zip(symp["texts"])
      not_na_values = zipped_values.select{|x| x[0] != 5}.sort{|a,b| b[0]<=>a[0]}

      median_length = not_na_values[not_na_values.length/2][1]
      above_year = symp["values"].select{|x| x == '4'}.length

      {name: symp["answer_template_name"], text: symp["answer_template_text"], freq: percentage(not_na_values.length, symp["total"]), median: median_length, above_year: percentage(above_year, symp["total"])}
    end

    by_symptom.sort{|a,b| b[:freq]<=>a[:freq]}
  end

  def self.sleep_test_stats
    test_query = Report.where(question_slug: 'diagnostic-study', locked: true, value: ['1', '2'])

    total = test_query.count
    home_percent = percentage(test_query.where(value: '1').count, total)
    center_percent = percentage(test_query.where(value: '2').count, total)

    home_as = test_query.where(value: '1').group(:answer_session_id).pluck(:answer_session_id)
    center_as = test_query.where(value: '2').group(:answer_session_id).pluck(:answer_session_id)

    satisfaction_query = Report.where(question_slug: 'sleep-study-satisfaction', locked: true)

    home_values = satisfaction_query.where(answer_session_id: home_as).pluck(:value)
    center_values = satisfaction_query.where(answer_session_id: center_as).pluck(:value)

    home_sat_percent = percentage(home_values.select{|x| ['5','6','7'].include? x }.length, home_values.length)
    center_sat_percent = percentage(center_values.select{|x| ['5','6','7'].include? x }.length, center_values.length)

    {home_percent: home_percent, home_sat_percent: home_sat_percent, center_percent: center_percent, center_sat_percent: center_sat_percent}
  end

  ## The core is answer value...



  ## Additional Info About Me
  def self.bmi(encounter, user)
    height = self.height(encounter, user)
    weight = self.weight(encounter, user)

    ((weight / (height * height)) * 703)
  end

  def self.height(encounter, user)
    Report.where(question_slug: 'height', encounter: encounter, user: user.id).pluck(:value)[0].to_f
  end

  def self.weight(encounter, user)
    Report.where(question_slug: 'weight', encounter: encounter, user: user.id).pluck(:value)[0].to_f
  end


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


  ## My Quality of Life

  def self.health_rating_data
    table_data = Report.frequency_data('general-health-rate', 1..5)
    return self.table_to_freq_array(table_data)
  end

  def self.health_improvement_data
    table_data = Report.frequency_data('improved-health-rate', 1..5)
    return self.table_to_freq_array(table_data)
  end

  def self.qol_rating_data
    table_data = Report.frequency_data('general-quality-life-rate', 1..5)
    return self.table_to_freq_array(table_data)
  end


  ## About my family

  def self.family_diagnostic_answer(encounter, user)
    answers = Report.where(encounter: encounter, survey_slug: 'about-my-family', question_slug: 'family-diagnoses', user: user.id, value: %w(1 2 3 4 5 6 7)).where.not(answer_option_text: ["1", "2", "3+"]).pluck(:answer_option_text)
    return answers.collect{|answer| answer.partition(' ').first}.join(', ')
  end

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
    return symptoms
  end

  ## My health conditions

  def self.comorbidity_map
    conditions = ["Allergies", "Asthma", "ADD", "ADHD", "Cancer", "COPD", "Depression", "Diabetes", "Epilepsy", "HBP", "Heart Disease", "Insomnia", "Narcolepsy", "Pulmonary Fibrosis", "Restless Legs", "Stroke"]
    data = []
    conditions.each do |condition|
      data.push(self.comorbidity_map_data(condition))
    end
    return data
  end

  def self.comorbidity_map_data(condition)
    at_name = 'conditions-' + condition.to_s.gsub(" ", "-").downcase
    r = Report.tabular_data(survey_slug: 'my-health-conditions', question_slug: 'health-conditions-list', answer_template_name: at_name).first
    return [condition.to_s, at_name, r[1]["frequency"]]
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
