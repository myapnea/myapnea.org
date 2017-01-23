# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  prepend_before_action :check_captcha, only: [:create]

  protected

  def after_sign_up_path_for(resource)
    get_started_path
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :over_eighteen, :email, :password, :beta_opt_in, :invite_token, :provider_id)
  end

  def check_captcha
    if RECAPTCHA_ENABLED && !verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.errors.add(:recaptcha, 'reCAPTCHA verification failed.')
      respond_with_navigational(resource) { render :new }
    end
  end
end
