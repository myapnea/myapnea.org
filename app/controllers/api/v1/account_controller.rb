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

end
