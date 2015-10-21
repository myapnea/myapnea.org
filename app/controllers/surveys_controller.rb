class SurveysController < ApplicationController
  before_action :set_active_top_nav_link_to_surveys
  before_action :authenticate_user!,                      except: [:index]
  before_action :authenticate_research,                   except: [:index]
  before_action :set_survey,                              only: [:show, :report, :report_detail, :accept_update_first]
  before_action :set_encounter,                           only: [:show, :report, :report_detail, :accept_update_first]
  before_action :set_answer_session,                      only: [:show, :report, :report_detail, :accept_update_first]
  before_action :redirect_without_answer_session,         only: [:show]
  before_action :redirect_without_accepted_recent_update, only: [:show]
  before_action :check_report_access,                     only: [:report, :report_detail]

  before_action :set_SEO_elements

  layout 'surveys'

  def index
    if current_user
      @surveys = Survey.current.viewable
      @answer_sessions = current_user.answer_sessions.where(child_id: nil).joins(:survey).merge( Survey.current.viewable ).order(:locked, "surveys.name_en", :encounter)
    else
      @surveys = Survey.current.viewable
    end
  end

  def show
  end

  def report
    unless @survey.has_custom_report?
      redirect_url = if @answer_session and @answer_session.child
        child_survey_report_detail_path(@answer_session.child.id, @answer_session.survey, @answer_session.encounter)
      elsif @answer_session
        report_detail_survey_path(@answer_session.survey, @answer_session.encounter)
      else
        report_detail_survey_path(@survey, @encounter)
      end
      redirect_to redirect_url
    end
  end

  def report_detail
  end

  def accept_update_first
    url = if @answer_session.child
      child_survey_path(@answer_session.child.id, @answer_session.survey, @answer_session.encounter)
    else
      show_survey_path(@answer_session.survey, @answer_session.encounter)
    end

    redirect_to url if current_user.accepted_most_recent_update?
    session[:return_to] = url
  end

  def process_answer
    @question = Question.find_by_param(params[:question_id])
    @answer_session = current_user.answer_sessions.find_by_id(params[:answer_session_id])
    response = params[:response] || {}

    if @answer_session and @question and @answer = @answer_session.process_answer(@question, response)
      render json: { completed: @answer.complete?, invalid: @answer.invalid?, value: @answer.string_value, errors: @answer.errors.full_messages, validation_errors: @answer.validation_errors }
    else
      head :no_content
    end
  end

  def submit
    if @answer_session = current_user.answer_sessions.find_by_id(params[:answer_session_id])
      @answer_session.lock! if @answer_session.completed?
      render json: { locked: @answer_session.locked? }
    else
      head :no_content
    end
  end

  private

  def set_survey
    @survey = Survey.current.viewable.includes(:questions).find_by_param(params[:id])
  end

  def set_encounter
    @encounter = Encounter.current.find_by_param(params[:encounter] || 'baseline')
  end

  def set_answer_session
    @answer_session = current_user.answer_sessions.where(survey_id: @survey.id, encounter: (params[:encounter] || 'baseline'), child_id: params[:child_id]).first if @survey
  end

  def redirect_without_answer_session
    redirect_to surveys_path unless @answer_session
  end

  def redirect_without_accepted_recent_update
    unless current_user.accepted_most_recent_update?
      redirect_to accept_update_first_survey_path(@answer_session.survey, @answer_session.encounter, @answer_session.child_id)
    end
  end

  def check_report_access
    if @answer_session and @answer_session.unlocked?
      if @answer_session.child
        redirect_to child_survey_path(@answer_session.child.id, @answer_session.survey, @answer_session.encounter)
      else
        redirect_to show_survey_path(@answer_session.survey, @answer_session.encounter)
      end
    elsif !@answer_session and !current_user.is_only_academic?
      redirect_to surveys_path
    end
  end

  def set_SEO_elements
    @page_title = @survey.present? ? ('Surveys - ' + @survey.name) : ('Participate in Research Surveys About Sleep Apnea')
    @page_content = 'Get paid to take research surveys about sleep apnea! Surveys ask for information about sleep quality, sleep apnea treatments, family involvement, and more.'
  end

end
