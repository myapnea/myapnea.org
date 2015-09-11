class Api::V1::AccountController < ApplicationController

  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  before_action :get_dob_question, only: [:set_dob, :check_dob]
  before_action :get_height_weight_question, only: [:set_height_weight, :check_height_weight]

  respond_to :json

  def home
    render json: { name: current_user.email }
  end

  def dashboard
    @about_me_survey = Survey.find_by_slug 'about-me'
  end

  def photo
    render json: { photo_url: current_user.api_photo_url }
  end

  def forum_name
    render json: { forum_name: current_user.forum_name }
  end

  def user_types
  end

  def set_user_types
    user_types = params.permit(:provider, :researcher, :adult_diagnosed, :adult_at_risk, :caregiver_adult, :caregiver_child)
    current_user.update_user_types user_types
  end

  def ready_for_research?
  end

  def accept_consent
    current_user.accepts_consent!
    current_user.update accepted_privacy_policy_at: Time.zone.now
  end

  # Onboarding process - survey questions

  def set_dob
    response = { @question.answer_templates.first.to_param => { month: params[:month], day: params[:day], year: params[:year] } }
    @dob_answer = @answer_session.process_answer(@question, response)
    render json: { success: @dob_answer.state == 'complete' }
  end

  def set_height_weight
    height_response = { @height_question.answer_templates.first.to_param => { feet: params[:feet], inches: params[:inches] } }
    weight_response = { @weight_question.answer_templates.first.to_param => params[:pounds] }
    @weight_answer = @answer_session.process_answer(@weight_question, weight_response)
    @height_answer = @answer_session.process_answer(@height_question, height_response)
    render json: { success: (@weight_answer.state == 'complete' and @height_answer.state == 'complete') }
  end

  # Check onboarding

  def check_dob
    render json: { present: TemporaryReport.get_value('date-of-birth', @answer_session).present? }
  end

  def check_height_weight
    render json: { present: (TemporaryReport.get_value('height', @answer_session).present? and TemporaryReport.get_value('weight', @answer_session).present?) }
  end

  private

    def get_dob_question
      @survey = Survey.current.viewable.find_by_slug('about-me')
      @answer_session = current_user.get_baseline_survey_answer_session(@survey)
      @question = @survey.questions.find_by_slug('date-of-birth')
    end

    def get_height_weight_question
      @survey = Survey.current.viewable.find_by_slug('additional-information-about-me')
      @answer_session = current_user.get_baseline_survey_answer_session(@survey)
      @height_question = @survey.questions.find_by_slug('height')
      @weight_question = @survey.questions.find_by_slug('weight')
    end

end
