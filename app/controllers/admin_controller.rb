class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner_or_moderator

  before_action :set_SEO_elements

  def dashboard
  end

  def research_topics
    @research_topics = ResearchTopic.where.not(topic_id: nil).order("created_at desc")
  end

  def surveys
  end

  def unlock_survey
    @user = User.current.find_by_id(params[:user_id])
    if @user and answer_session = @user.answer_sessions.find_by_id(params[:answer_session_id])
      answer_session.unlock!
    end
    if @user
      redirect_to @user, notice: 'Survey unlocked successfully.'
    else
      redirect_to users_path
    end
  end

  def providers
    @providers = User.current.where(provider: true)
  end

  def version_stats
    @version_dates = [
      { version: '7.4.0', release_date: Date.parse('2015-08-07'), next_release_date: nil },
      { version: '7.3.0', release_date: Date.parse('2015-07-07'), next_release_date: Date.parse('2015-08-07') },
      { version: '7.2.0', release_date: Date.parse('2015-06-24'), next_release_date: Date.parse('2015-07-07') },
      { version: '7.1.0', release_date: Date.parse('2015-06-03'), next_release_date: Date.parse('2015-06-24') },
      { version: '7.0.0', release_date: Date.parse('2015-06-01'), next_release_date: Date.parse('2015-06-03') },
      { version: '6.1.0', release_date: Date.parse('2015-04-27'), next_release_date: Date.parse('2015-06-01') },
      { version: '6.0.0', release_date: Date.parse('2015-04-15'), next_release_date: Date.parse('2015-04-27') },
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

  def location
  end

  def ages
  end

  def cross_tabs
    user_values = {}

    # Age
    survey = Survey.find_by_slug 'about-me'
    question = survey.questions.find_by_slug 'date-of-birth'
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.select(:id) ).where.not( text_value: [nil, '']).includes(answer: :answer_session).pluck(:text_value, "answer_sessions.user_id")
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
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

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
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

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
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

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
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

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
    values_and_ids = AnswerValue.current.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

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

  def engagement_report
    @uploaded_photo_count = User.current.where.not(photo: nil).count
    @introduced_count = Topic.find_by_slug('introduce-yourself').posts.current.uniq.count
    @discussed_count = Post.current.not_research.where.not(topic_id: Topic.find_by_slug('introduce-yourself')).uniq.select(:user_id).count
    @completing_surveys_count = AnswerSession.current.where(completed: true).uniq.select(:user_id).count
    @experienced_voter_count = User.current.joins(:votes).group(user_group_columns).having('count(votes.id) > 9').to_a.count
    @submitted_research_topic_count = ResearchTopic.current.uniq.pluck(:user_id).count
    @invited_members_count = Invite.members.uniq.select(:user_id).count
    @invited_members_success_count = Invite.members.successful.uniq.select(:user_id).count
    @invited_providers_count = Invite.providers.uniq.select(:user_id).count
    @invited_providers_success_count = Invite.providers.successful.uniq.select(:user_id).count
  end

  def daily_engagement
    redirect_to admin_path and return unless current_user.owner?
    @date = Date.today
    daily_data(@date, @date)
  end

  def daily_demographic_breakdown
    start_date = params[:breakdown_date_start]
    @date1 = Date.new start_date["(1i)"].to_i, start_date["(2i)"].to_i, start_date["(3i)"].to_i
    end_date = params[:breakdown_date_end]
    @date2 = Date.new end_date["(1i)"].to_i, end_date["(2i)"].to_i, end_date["(3i)"].to_i

    daily_data(@date1, @date2)

    respond_to do |format|
      format.js
    end
  end

  def daily_engagement_data
    dates = (Date.parse("02-10-2014").to_date..Date.today).map{ |date| [date.strftime("%a, %d %b %Y").to_date, []] }
    @posts = dates
    Post.current.select(:id, :created_at).group_by{ |post| post.created_at.to_date }.each do |post|
      @posts[dates.index([post[0], []])] = post
    end

    dates = (Date.parse("02-10-2014").to_date..Date.today).map{ |date| [date.strftime("%a, %d %b %Y").to_date, []] }
    @surveys = dates
    AnswerSession.current.where(locked: true).select(:id, :updated_at).group_by{ |as| as.updated_at.to_date }.each do |survey|
      @surveys[dates.index([survey[0], []])] = survey
    end

    dates = (Date.parse("02-10-2014").to_date..Date.today).map{ |date| [date.strftime("%a, %d %b %Y").to_date, []] }
    @users = dates
    User.current.select(:id, :created_at).group_by{ |user| user.created_at.to_date }.each do |user|
      @users[dates.index([user[0], []])] = user
    end
  end

  def user_group_columns
    User.column_names.map{|cn| "users.#{cn}"}.join(", ")
  end

  private

    def set_SEO_elements
      @page_title = 'Admin Panel'
      @page_content = 'Administrative panel only for owners and moderators of MyApnea.'
    end

    def daily_data(date1, date2)
      @users_by_date = User.where("created_at >= ? AND created_at <= ?", date1.beginning_of_day, date2.end_of_day)
      # Ages
      dobs = Report.where(question_slug: 'date-of-birth', locked: true, user_id: @users_by_date.pluck(:id)).where.not(value: "").pluck('value')
      @ages = Hash.new
      @ages[0] = {text: "18-34", count: 0}
      @ages[1] = {text: "35-49", count: 0}
      @ages[2] = {text: "50-64", count: 0}
      @ages[3] = {text: "65-75", count: 0}
      @ages[4] = {text: "76+", count: 0}
      dobs.each do |dob|
        case ((Date.today - Date.strptime(dob,"%m/%d/%Y")).days / 1.year rescue nil)
        when 18..35
          @ages[0][:count]+= 1
        when 35..50
          @ages[1][:count]+= 1
        when 50..65
          @ages[2][:count]+= 1
        when 65..75
          @ages[3][:count]+= 1
        when 75..200
          @ages[4][:count]+= 1
        else
          nil
        end
      end
    end

end
