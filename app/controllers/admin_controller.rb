# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner_or_moderator

  before_action :set_SEO_elements

  def dashboard
  end

  def social_media
  end

  # GET /admin/spam-inbox
  def spam_inbox
    @spammers = spammers
  end

  # POST /admin/unspamban/:id
  def unspamban
    member = spammers.find_by(id: params[:id])
    if member
      member.update(spammer: false)
      flash[:notice] = "Member marked as not a spammer. You may still need to unshadow ban them."
    end
    redirect_to admin_spam_inbox_path
  end

  # POST /admin/empty-spam
  def empty_spam
    Chapter.current.where(user: spammers).destroy_all
    spammers.update_all(spammer: true)
    spammers.destroy_all
    redirect_to admin_spam_inbox_path, notice: "All spammers have been deleted."
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

  def timeline
    @first_month = Date.parse("2014-10-01")
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
    values_and_ids = AnswerValue.where( answer_id: question.answers.select(:id) ).where.not( text_value: [nil, '']).includes(answer: :answer_session).pluck(:text_value, "answer_sessions.user_id")
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
    values_and_ids = AnswerValue.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

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
    values_and_ids = AnswerValue.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []
      user_values[user_id.to_s][:race] ||= []

      new_race = case v when "White (a person having origins in any of the original peoples of Europe, the Middle East, or North Africa)"
        'White'
      when "Black or African American (a person having origins in any of the black racial groups of Africa)"
        'Black'
      when 'Prefer not to answer'
        nil
      else
        'Other'
      end

      user_values[user_id.to_s][:race] = (user_values[user_id.to_s][:race] | [new_race]) if new_race
    end

    # Education level
    question = survey.questions.find_by_slug 'education-level'
    values_and_ids = AnswerValue.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

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
      else
        nil
      end

      user_values[user_id.to_s][:education] = education_level
    end

    # Wealth
    survey = Survey.find_by_slug 'additional-information-about-me'
    question = survey.questions.find_by_slug 'affording-basics'
    values_and_ids = AnswerValue.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []
      wealth_difficulty = case v when "Not very hard"
        'Not very hard'
      else
        'All other options'
      end

      user_values[user_id.to_s][:wealth] = wealth_difficulty
    end

    # Referral
    survey = Survey.find_by_slug 'my-interest-in-research'
    question = survey.questions.find_by_slug 'referral-methods'
    values_and_ids = AnswerValue.where( answer_id: question.answers.select(:id) ).where.not( answer_option_id: nil ).includes(:answer_option, answer: :answer_session).pluck("answer_options.text", "answer_sessions.user_id")

    values_and_ids.each do |v,user_id|
      user_values[user_id.to_s] ||= {}
      user_values[user_id.to_s][:referral] ||= []

      new_value = case v when "American Sleep Apnea Association (ASAA)"
        'ASAA'
      when "Facebook", "Twitter", "Internet search", "Other patient-centered network"
        'Internet'
      else
        'Other'
      end

      user_values[user_id.to_s][:referral] = (user_values[user_id.to_s][:referral] | [new_value]) if new_value
    end

    @age_ranges = age_ranges
    @user_values = user_values
  end

  private

  def spammers
    User.current.where(shadow_banned: true, spammer: [nil, true])
  end

  def set_SEO_elements
    @title = 'Admin Panel'
    @page_content = 'Administrative panel only for owners and moderators of MyApnea.'
  end

  def daily_data(date1, date2)
    @users_by_date = User.where("created_at >= ? AND created_at <= ?", date1.beginning_of_day, date2.end_of_day)

    @survey = Survey.current.find_by_slug 'about-me'
    @encounter = Encounter.current.find_by_slug 'baseline'

    question = @survey.questions.find_by_slug 'date-of-birth'
    dobs = question.community_answer_text_values(@encounter).joins(answer: :answer_session).where(answer_sessions: { user_id: @users_by_date.select(:id) }).where.not(text_value: ['', nil]).pluck(:text_value)

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
