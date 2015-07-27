class SurveysController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_active_top_nav_link_to_surveys
  before_action :authenticate_research, except: [:index]
  before_action :set_survey, only: [:show, :report, :report_detail, :accept_update_first, :start_survey]

  before_action :set_SEO_elements

  def my_health_conditions_data
    @data = Report.comorbidity_map.push(["Sleep Apnea", "conditions-sleep-apnea", 100])
  end

  def index
    if current_user
      @surveys = current_user.is_only_academic? ? Survey.viewable : current_user.assigned_surveys
    else
      @surveys = Survey.viewable
    end
  end

  def show
    redirect_to surveys_path and return if @survey.deprecated?
    unless current_user.accepted_most_recent_update?
      redirect_to accept_update_first_survey_path and return
    end
    render layout: 'layouts/application-central-padding'
    # We do not want to redirect to survey report path if it's completed, we
    # want to show the survey page, with locked questions instead. ~ Remo
    # redirect_to report_survey_path(@survey, @answer_session) and return if @answer_session.completed?
  end

  def report
    check_report_access
  end

  def report_detail
    check_report_access
  end

  def accept_update_first
    redirect_to survey_path(@survey) if current_user.accepted_most_recent_update?
    session[:return_to] = survey_path(@survey)
  end

  def process_answer
    @question = Question.find_by_id(params[:question_id])
    @answer_session = current_user.answer_sessions.find_by_id(params[:answer_session_id])

    if @answer_session and @question and @answer = @answer_session.process_answer(@question, params)
      render json: { completed: @answer.complete?, invalid: @answer.invalid?, value: @answer.string_value, errors: @answer.errors.full_messages, validation_errors: @answer.validation_errors }
    else
      head :no_content
    end

  end

  def submit
    @answer_session = AnswerSession.find(params[:answer_session_id])
    @answer_session.lock if @answer_session.completed?

    render json: { locked: @answer_session.locked? }
  end

  private

  def set_survey
    @survey = Survey.where("slug = ? or id = ?", params[:id], params[:id].to_i).includes(:ordered_questions).first
    @answer_session = AnswerSession.where(user_id: current_user.id, survey_id: @survey.id).order("created_at desc").first

    if @answer_session.blank?
      redirect_to surveys_path and return unless current_user.is_only_academic?
    end
  end

  def check_report_access
    redirect_to surveys_path and return unless ((@answer_session.present? and @answer_session.completed?) or current_user.is_only_academic?)
  end

  def set_SEO_elements
    @page_title = @survey.present? ? ('Surveys - ' + @survey.name) : ('Participate in Research Surveys About Sleep Apnea')
    @page_content = 'Get paid to take research surveys about sleep apnea! Surveys ask for information about sleep quality, sleep apnea treatments, family involvement, and more.'
  end

end
