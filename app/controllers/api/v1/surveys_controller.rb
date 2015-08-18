class Api::V1::SurveysController < ApplicationController


  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  before_action :set_survey,                          only: [:show]
  before_action :redirect_without_survey,             only: [:show]

  respond_to :json

  def show
  end

  def process_answer
    @question = Question.find_by_id(params[:question_id])
    @answer_session = current_user.answer_sessions.find_by_id(params[:answer_session_id])
    response = params[:response] || {}

    if @answer_session and @question and @answer = @answer_session.process_answer(@question, response)
      render json: { success: true, completed: @answer.complete?, invalid: @answer.invalid?, value: @answer.string_value, errors: @answer.errors.full_messages, validation_errors: @answer.validation_errors }
    else
      render json: { success: false }
      # head :no_content
    end
  end

  def answer_sessions
    @answer_sessions = current_user.answer_sessions
    respond_to do |format|
      format.json
    end
  end

  private

    def set_survey
      @survey = Survey.find_by_id(params[:id])
    end

    def redirect_without_survey
      head :no_content unless @survey
    end

end
