class AccountController < ApplicationController
  before_action :authenticate_user!, except: [:consent, :privacy_policy, :terms_and_conditions, :terms_of_access]

  def get_started
  end

  def get_started_privacy
  end

  def get_started_terms_of_access
  end

  def get_started_provider_profile
  end

  def get_started_social_profile
    current_user.create_social_profile
  end

  def get_started_consent
  end

  def get_started_about_me
    if current_user
      @survey = Survey.find_by_slug("about-me")
      @answer_session = AnswerSession.find_or_create(current_user, @survey)
    end
  end

  def accepts_terms_of_access
    current_user.update accepted_terms_of_access_at: Time.zone.now
    if current_user.provider?
      redirect_to get_started_provider_profile_path
    elsif current_user.is_only_researcher?
      redirect_to get_started_social_profile_path
    else
      redirect_to home_path
    end
  end

  def privacy_policy
    if params[:privacy_policy_read]
      current_user.update accepted_privacy_policy_at: Time.zone.now
      if current_user.ready_for_research?
        redirect_to (session[:return_to].present? ? session.delete(:return_to) : surveys_path), notice: "You have now signed the consent and are ready to participate in research. You can opt out any time by visiting your user account settings."
      else
        redirect_to consent_path, notice: "Please read over and accept the research consent before participating in research."
      end
    else
      load_content
    end
  end

  def accepts_privacy
    current_user.update accepted_privacy_policy_at: Time.zone.now
    # TODO Remove when update is changed
    current_user.update(accepted_update_at: Time.zone.now)
    # end todo
    if current_user.is_only_academic? and !current_user.ready_for_research?
      redirect_to get_started_terms_of_access_path
    elsif !current_user.ready_for_research?
      redirect_to get_started_consent_path
    else
      redirect_to get_started_about_me_path
    end
  end

  def consent
    if params[:consent_read]
      current_user.update_attribute(:accepted_consent_at, Time.zone.now)
      if current_user.ready_for_research?
        redirect_to (session[:return_to].present? ? session.delete(:return_to) : surveys_path), notice: "You have now signed the consent and are ready to participate in research."
      else
        redirect_to privacy_path, notice: "Please read over and accept the privacy policy before participating in research. You can opt out any time by visiting your user account settings."
      end
    else
      load_content
    end
  end

  def accepts_consent
    current_user.update(accepted_consent_at: Time.zone.now)
    if !current_user.ready_for_research?
      redirect_to get_started_privacy_path
    elsif current_user.is_provider?
        redirect_to get_started_provider_profile_path
    else
      redirect_to get_started_about_me_path
    end
  end

  def revoke_consent
    current_user.revoke_consent!
    redirect_to home_path, notice: "You have successfully left the research study portion of MyApnea.Org. If you ever change your mind, just visit your account settings to view the research consent and privacy policy again."
  end

  def accepts_update
    current_user.update(accepted_update_at: Time.zone.now)
    redirect_to session[:return_to] || root_path
  end


  def user_type
  end

  def set_user_type
    user_types = params.required(:user).permit(:provider, :researcher, :adult_diagnosed, :adult_at_risk, :caregiver_adult, :caregiver_child)
    current_user.update_user_types user_types
    if params[:registration_process] == '1'
      redirect_to get_started_privacy_path
    else
      redirect_to account_path
    end
  end

  def dashboard

  end

  def account
    @social_profile = current_user.social_profile || current_user.create_social_profile
  end

  def terms_and_conditions
  end

  def accepts_terms_and_conditions
    current_user.update(accepted_terms_conditions_at: Time.zone.now)
    redirect_to session[:return_to] || forums_path
  end

  def terms_of_access
    if params[:terms_of_access_read]
      current_user.update(accepted_terms_of_access_at: Time.zone.now)
      if current_user.ready_for_research?
        redirect_to (session[:return_to].present? ? session.delete(:return_to) : surveys_path), notice: "You have now signed the terms of access and are ready to participate in research."
      else
        redirect_to privacy_path, notice: "Please read over and accept the privacy policy before participating in research. You can opt out any time by visiting your user account settings."
      end
    else
    end

  end

  def update
    if current_user.update(user_params)
      if [:welcome_message, :slug, :provider_name].all? {|k| user_params.key? k}
        redirect_to provider_path(current_user.slug)
      else
        redirect_to account_path, notice: "Your account settings have been successfully changed."
      end
    else
      @update_for = :user_info
      render "account"
    end
  end

  def change_password
    if current_user.update_with_password(user_params)
      # Sign in the user by passing validation in case the user's password changed
      sign_in current_user, bypass: true
      redirect_to account_path, alert: "Your password has been changed."
    else
      @update_for = :password
      render "account"
    end
  end

  private

  def user_params
    params.required(:user).permit(:email, :first_name, :last_name, :zip_code, :year_of_birth, :password, :password_confirmation, :current_password, :beta_opt_in, :state_code, :country_code, :provider_id, :welcome_message, :photo, :remove_photo, :emails_enabled, :slug, :provider_name)
  end

  def load_content
    @pc = YAML.load_file(Rails.root.join('lib', 'data', 'myapnea', 'content', "#{action_name}.#{I18n.locale}.yml"))[I18n.locale.to_s][action_name.to_s]
  end

end
