class Api::V1::AccountController < ApplicationController

  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  respond_to :json

  def user_types
  end

  def set_user_types
    user_types = params.required(:user).permit(:provider, :researcher, :adult_diagnosed, :adult_at_risk, :caregiver_adult, :caregiver_child)
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
    @survey = Survey.current.viewable.find_by_slug('about-me')
    @answer_session = current_user.get_baseline_survey_answer_session(@survey)
    @question = Question.find_by_slug('date-of-birth')
    response = { @question.answer_templates.first.to_param => { month: params[:month], day: params[:day], year: params[:year] } }
    if @answer_session and @question and @dob_answer = @answer_session.process_answer(@question, response)
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def set_height_weight
    @survey = Survey.current.viewable.find_by_slug('additional-information-about-me')
    @answer_session = current_user.get_baseline_survey_answer_session(@survey)
    @height_question = Question.find_by_slug('height')
    height_response = { @height_question.answer_templates.first.to_param => { feet: params[:feet], inches: params[:inches] } }
    @weight_question = Question.find_by_slug('weight')
    weight_response = { @weight_question.answer_templates.first.to_param => params[:pounds] }
    if @answer_session and @weight_question and @height_question and @weight_answer = @answer_session.process_answer(@weight_question, weight_response) and @height_answer = @answer_session.process_answer(@height_question, height_response)
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

end
