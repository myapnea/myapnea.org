class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner_or_moderator

  def dashboard
  end

  def research_topics
    @research_topics = ResearchTopic.all.order("created_at desc")
  end

  def research_topic
    @research_topic = ResearchTopic.find(params[:id])
  end

  def surveys
  end

  def version_stats
    @version_dates = [
      { version: '6.0.0', release_date: Date.parse('2015-04-15'), next_release_date: nil },
      { version: '5.2.0', release_date: Date.parse('2015-03-25'), next_release_date: Date.parse('2015-04-15') },
      { version: '5.1.0', release_date: Date.parse('2015-03-13'), next_release_date: Date.parse('2015-03-25') },
      { version: '5.0.0', release_date: Date.parse('2015-03-04'), next_release_date: Date.parse('2015-03-13') },
      { version: '4.2.0', release_date: Date.parse('2015-01-29'), next_release_date: Date.parse('2015-03-04') },
      { version: '4.1.0', release_date: Date.parse('2015-01-21'), next_release_date: Date.parse('2015-01-29') },
      { version: '4.0.0', release_date: Date.parse('2015-01-15'), next_release_date: Date.parse('2015-01-21') },
      { version: '3.2.0', release_date: Date.parse('2015-01-08'), next_release_date: Date.parse('2015-01-15') },
      { version: '3.1.0', release_date: Date.parse('2015-01-02'), next_release_date: Date.parse('2015-01-08') },
      { version: '3.0.0', release_date: Date.parse('2014-12-16'), next_release_date: Date.parse('2015-01-02') },
      { version: '2.1.0', release_date: Date.parse('2014-12-10'), next_release_date: Date.parse('2014-12-16') },
      { version: '2.0.0', release_date: Date.parse('2014-11-14'), next_release_date: Date.parse('2014-12-10') },
      { version: '1.1.0', release_date: Date.parse('2014-10-17'), next_release_date: Date.parse('2014-11-14') },
      { version: '1.0.0', release_date: Date.parse('2014-10-03'), next_release_date: Date.parse('2014-10-17') },
      { version: 'Before 1.0.0', release_date: nil, next_release_date: Date.parse('2014-10-03') }
    ]
  end

  def cross_tabs
    user_values = {}

    # Age
    survey = Survey.find_by_slug 'about-me'
    question = survey.questions.find_by_slug 'date-of-birth'
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.pluck(:id) ).where.not( text_value: [nil, '']).includes(answer: :answer_session).pluck(:text_value, "answer_sessions.user_id")
    date_values_and_ids = values_and_ids.collect{|v, user_id| [Date.parse(v), user_id] rescue nil}.compact.select{|d, user_id| d.year.in?(1900..Date.today.year)}

    age_ranges = [["18-34", (18..34)],
     ["35-49", (35..49)],
     ["50-64", (50..64)],
     ["65-75", (65..75)],
     ["76+", (76..200)]]

    age_ranges.each do |age_display, age_range|
      date_values_and_ids.each do |d, user_id|
        user_values[user_id.to_s] ||= {}
        user_values[user_id.to_s][:referral] ||= []
        age_in_years = (Date.today - d).days / 1.year
        user_values[user_id.to_s][:age] = age_display if age_in_years.in?(age_range)
      end
    end

    # Sex
    question = survey.questions.find_by_slug 'sex'
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.pluck(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []
      sex = case v when "Male"
        'Male'
      when "Female"
        'Female'
      else
        nil
      end

      user_values[user_id.to_s][:sex] = sex
    end

    # Race
    question = survey.questions.find_by_slug 'race'
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.pluck(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []
      user_values[user_id.to_s][:race] ||= []

      new_race = case v when "White (a person having origins in any of the original peoples of Europe, the Middle East, or North Africa)"
        'White'
      when "Black or African American (a person having origins in any of the black racial groups of Africa)"
        'Black'
      when nil
        nil
      else
        'Other'
      end

      user_values[user_id.to_s][:race] = (user_values[user_id.to_s][:race] | [new_race]) if new_race
      puts user_values[user_id.to_s][:race]

    end


    # Education level
    question = survey.questions.find_by_slug 'education-level'
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.pluck(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []
      education_level = case v when "8th grade or less", "Some high school, but did not graduate", "High school graduate or GED"
        'High school or less'
      when "Some college or 2-year degree"
        'Some college'
      when "4-year college graduate"
        '4-year college graduate'
      when "More than 4-year college degree"
        'More than 4-year college'
      when nil
        nil
      else
        'Other'
      end

      user_values[user_id.to_s][:education] = education_level
    end

    # Wealth
    survey = Survey.find_by_slug 'additional-information-about-me'
    question = survey.questions.find_by_slug 'affording-basics'
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.pluck(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []
      wealth_difficulty = case v when "Not very hard"
        'Not very hard'
      when nil
        nil
      else
        'All other options'
      end

      user_values[user_id.to_s][:wealth] = wealth_difficulty
    end

    # Referral
    survey = Survey.find_by_slug 'my-interest-in-research'
    question = survey.questions.find_by_slug 'referral-methods'
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.pluck(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []

      new_value = case v when "American Sleep Apnea Association (ASAA)"
        'ASAA'
      when "Facebook", "Twitter", "Internet search", "Other patient-centered network"
        'Internet'
      when nil
        nil
      else
        'Other'
      end

      user_values[user_id.to_s][:referral] = (user_values[user_id.to_s][:referral] | [new_value]) if new_value
    end

    @age_ranges = age_ranges
    @user_values = user_values
  end

  def notifications
    @posts = Notification.notifications
    @new_post = Notification.new(post_type: :notification)
  end

end
