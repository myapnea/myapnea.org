class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_active_top_nav_link_to_surveys
  before_action :authenticate_research
  before_action :set_survey, only: [:show, :report, :start_survey]


  def about_me_mockup
    render 'surveys/reports/about_me'
  end

  def my_sleep_pattern_mockup
    render 'surveys/reports/my_sleep_pattern'
  end

  def my_health_conditions_mockup
    render 'surveys/reports/my_health_conditions'
  end

  def my_health_conditions_data
    @survey = Survey.find_by_slug("my-health-conditions")
  end

  def my_sleep_apnea_treatment_mockup
    render 'surveys/reports/my_sleep_apnea_treatment'
  end

  def my_sleep_quality_mockup
    render 'surveys/reports/my_sleep_quality'
  end

  def additional_information_about_me_mockup
    render 'surveys/reports/additional_information_about_me'
  end

  def about_my_family_mockup
    render 'surveys/reports/about_my_family'
  end

  def my_quality_of_life_mockup
    render 'surveys/reports/my_quality_of_life'
  end

  def index
    @surveys = current_user.assigned_surveys
  end

  def show
    redirect_to surveys_path and return if @survey.deprecated?
    # We do not want to redirect to survey report path if it's completed, we
    # want to show the survey page, with locked questions instead. ~ Remo
    # redirect_to report_survey_path(@survey, @answer_session) and return if @answer_session.completed?
  end

  def report
    redirect_to surveys_path and return unless (@answer_session.completed? or current_user.is_only_academic?)
  end

  def process_answer
    @questions = Question.where(id: params[:question_id])
    @answer_session = AnswerSession.find(params[:answer_session_id]) # Validate user!

    @questions.each do |question|
      @answer = @answer_session.process_answer(question, params)
    end

    respond_to do |format|
      format.json { render json: {completed: @answer.complete?, answer: @answer, value: @answer.string_value, errors: @answer.errors.full_messages } }
    end

  end

  def submit
    @answer_session = AnswerSession.find(params[:answer_session_id])
    @answer_session.lock_answers if @answer_session.completed?

    render json: { locked: @answer_session.locked? }
  end

  private

  def set_survey
    @survey = Survey.where("slug = ? or id = ?", params[:id], params[:id].to_i).first
    @answer_session = AnswerSession.where(user_id: current_user.id, survey_id: @survey.id).order("created_at desc").first

    redirect_to surveys_path and return unless @answer_session.present?

  end

end
