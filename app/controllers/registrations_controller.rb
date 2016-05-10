# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController

  layout 'home'

  respond_to :json

  skip_before_action :verify_authenticity_token, only: [ :create ]

  protected

  def after_sign_up_path_for(resource)
    get_started_path
  end

  private

  def sign_up_params
    if params[:user][:provider]
      params.require(:user).permit(:first_name, :last_name,                 :email, :password, :beta_opt_in, :invite_token, :provider, :welcome_message)
    else
      params.require(:user).permit(:first_name, :last_name, :over_eighteen, :email, :password, :beta_opt_in, :invite_token, :provider_id)
    end

  end

end
