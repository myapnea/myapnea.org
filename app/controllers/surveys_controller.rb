class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_active_top_nav_link_to_surveys
  before_action :authenticate_research
  before_action :set_survey, only: [:show, :show_report, :start_survey]



  def index
    @surveys = (current_user.is_only_academic?) ? @surveys = Survey.viewable : current_user.assigned_surveys
  end

  def show
    redirect_to surveys_path and return if @survey.deprecated?
    # We do not want to redirect to survey report path if it's completed, we
    # want to show the survey page, with locked questions instead. ~ Remo
    # redirect_to survey_report_path(@survey, @answer_session) and return if @answer_session.completed?
  end

  def show_report
    redirect_to surveys_path and return unless @answer_session.completed?
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

    respond_to do |format|
      format.json do
        if @answer_session.completed?
          @answer_session.lock_answers
        end

        render json: { locked: @answer_session.locked? }

      end
    end
  end

  private

  def set_survey
    @survey = Survey.where("slug = ? or id = ?", params["slug"], params["slug"].to_i).first
    @answer_session = AnswerSession.where(user_id: current_user.id, survey_id: @survey.id).order("created_at desc").first

    redirect_to surveys_path and return unless @answer_session.present?

  end

end
