class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_active_top_nav_link_to_surveys
  before_action :authenticate_research
  before_action :set_survey, only: [:show, :report, :report_detail, :start_survey]


  def my_health_conditions_data
    @data = Report.comorbidity_map.push(["Sleep Apnea", "conditions-sleep-apnea", 100])
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

  def report_detail
    redirect_to surveys_path and return unless (@answer_session.completed? or current_user.is_only_academic?)
  end

  def process_answer
    @questions = Question.where(id: params[:question_id])
    @answer_session = AnswerSession.find(params[:answer_session_id]) # Validate user!

    @questions.each do |question|
      @answer = @answer_session.process_answer(question, params)
    end

    respond_to do |format|
      format.json { render json: {completed: @answer.complete?, invalid: @answer.invalid?, answer: @answer, value: @answer.string_value, errors: @answer.errors.full_messages, validation_errors: @answer.validation_errors } }
    end

  end

  def submit
    @answer_session = AnswerSession.find(params[:answer_session_id])
    @answer_session.lock if @answer_session.completed?

    render json: { locked: @answer_session.locked? }
  end

  private

  def set_survey
    @survey = Survey.where("slug = ? or id = ?", params[:id], params[:id].to_i).first
    @answer_session = AnswerSession.where(user_id: current_user.id, survey_id: @survey.id).order("created_at desc").first

    redirect_to surveys_path and return unless @answer_session.present?

  end

end
