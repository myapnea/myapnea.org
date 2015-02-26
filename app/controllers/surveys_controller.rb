class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_active_top_nav_link_to_surveys
  before_action :authenticate_research
  before_action :set_survey, only: [:show, :show_report, :start_survey]



  def index
    @surveys = (current_user.is_provider? or current_user.is_only_researcher?) ? @surveys = Survey.viewable.first(3) : current_user.assigned_surveys
  end

  def show
    redirect_to intro_survey_path(@survey) and return if @survey.deprecated?
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
      format.html do
        ## Deprecated - to be removed in Version 6.0.0. Answers will only be processed using AJAX.
        if @answer_session.completed?
          #raise StandardError, @answer_session.survey.to_param
          redirect_to survey_report_path(@answer_session.survey, @answer_session)
        else
          redirect_to ask_question_path(question_id: @answer.next_question.id, answer_session_id: @answer_session.id)
        end
        ##
      end
      format.json { render json: {completed: @answer.complete?, answer: @answer, value: @answer.string_value, errors: @answer.errors.full_messages } }
    end

  end

  ## Deprecated - to be removed in Version 6.0.0d
  def start_survey

    if @answer_session.completed?
      redirect_to surveys_path
    else
      redirect_to ask_question_path(question_id: @answer_session.next_question.id, answer_session_id: @answer_session.id)
    end
  end

  def intro
    # @survey = Survey.find(params[:slug])
    @survey = Survey.where("slug = ? or id = ?", params["slug"], params["slug"].to_i).first
  end


  def ask_question
    @answer_session = AnswerSession.find(params[:answer_session_id])
    @question = Question.find(params[:question_id])

    if @question.part_of_group?
      @group = @question.group
      @questions = @group.minimum_set(@answer_session.survey)
      @answer = Answer.current.where(question_id: @questions.first.id, answer_session_id: @answer_session.id).first || Answer.new(question_id: @questions.first.id, answer_session_id: @answer_session.id)
    else
      @answer = Answer.current.where(question_id: @question.id, answer_session_id: @answer_session.id).first || Answer.new(question_id: @question.id, answer_session_id: @answer_session.id)
    end
  end
  ##

  private

  def set_survey
    @survey = Survey.where("slug = ? or id = ?", params["slug"], params["slug"].to_i).first
    @answer_session = AnswerSession.where(user_id: current_user.id, survey_id: @survey.id).order("created_at desc").first

    redirect_to surveys_path and return unless @answer_session.present?

  end

end
