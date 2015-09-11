class AccountController < ApplicationController

  before_action :authenticate_user!, except: [:consent, :privacy_policy, :terms_and_conditions, :terms_of_access]
  before_action :set_SEO_elements

  layout 'application-no-sidebar', only: [:get_started, :get_started_step_two, :get_started_step_three, :terms_and_conditions, :account]

  ## Onboarding process

  def get_started
  end

  def get_started_step_two
  end

  def get_started_step_three
    if !(current_user.provider? or current_user.is_only_researcher?) and current_user.ready_for_research?
      @survey = Survey.current.viewable.find_by_slug("about-me")
      @answer_session = current_user.get_baseline_survey_answer_session(@survey)
      render layout: 'application-central-padding'
    end
  end

  ## Methods for consent, privacy, and terms of access

  def accepts_privacy
    current_user.update accepted_privacy_policy_at: Time.zone.now
    redirect_to current_user.ready_for_research? ? surveys_path : consent_path
  end

  def accepts_consent
    current_user.accepts_consent!
    if params[:get_started]
      current_user.update accepted_privacy_policy_at: Time.zone.now
      redirect_to get_started_step_three_path
    else
      redirect_to current_user.ready_for_research? ? surveys_path : privacy_path
    end
  end

  def accepts_terms_of_access
    current_user.accepts_terms_of_access!
    if params[:get_started]
      current_user.update accepted_privacy_policy_at: Time.zone.now
      redirect_to get_started_step_three_path
    else
      redirect_to current_user.ready_for_research? ? surveys_path : privacy_path
    end
  end

  def accepts_update
    (current_user.provider? or current_user.is_only_researcher?) ? current_user.accepts_terms_of_access! : current_user.accepts_consent!
    redirect_to (session[:return_to] || root_path)
  end

  def accepts_terms_and_conditions
    current_user.update(accepted_terms_conditions_at: Time.zone.now)
    redirect_to session[:return_to] || forums_path
  end

  def revoke_consent
    current_user.revoke_consent!
    redirect_to root_path, notice: "You have successfully left the research study portion of MyApnea.Org. If you ever change your mind, just visit your account settings to view the research consent and privacy policy again."
  end

  ## Content for consent, privacy, and terms of access

  def privacy_policy
    load_content
  end

  def consent
    load_content
  end

  def terms_of_access
  end

  def terms_and_conditions
  end

  def user_type
  end

  def set_user_type
    user_types = params.required(:user).permit(:provider, :researcher, :adult_diagnosed, :adult_at_risk, :caregiver_adult, :caregiver_child)
    current_user.update_user_types user_types
    if params[:registration_process] == '1'
      redirect_to get_started_step_two_path
    else
      redirect_to account_path
    end
  end

  def dashboard

  end

  def account
  end

  def update
    if current_user.update(user_params)
      if [:welcome_message, :slug, :provider_name].all? {|k| user_params.key? k}
        current_user.send_provider_informational_email! if current_user.provider?
        redirect_to provider_path(current_user.slug)
      else
        respond_to do |format|
          format.js
          format.all { redirect_to account_path, notice: "Your account settings have been successfully changed." }
        end
      end
    else
      render "account"
    end
  end

  def change_password
    if current_user.update_with_password(user_password_params)
      # Sign in the user by passing validation in case the user's password changed
      sign_in current_user, bypass: true
      redirect_to account_path, notice: "Your password has been changed."
    else
      render "account"
    end
  end

  def suggest_random_forum_name
    @new_forum_name = SocialProfile.generate_forum_name(Time.now.nsec.to_s)
  end

  private

    def user_params
      params[:user] ||= { blank: '1' }

      params[:user][:user_is_updating] = '1'

      params.required(:user).permit(
        # Basic Information
        :first_name, :last_name, :email,
        # Forum and Social Profile
        :photo, :remove_photo, :forum_name, :age, :gender,
        # Linking to a Provider
        :provider_id,
        # Receiving Emails
        :emails_enabled,
        # For Provider Profiles
        :welcome_message, :provider_name, :slug,
        # Enabling Beta
        :beta_opt_in,
        # Enforces that forum name can't be blank
        :user_is_updating
        )
    end

    def user_password_params
      params.required(:user).permit(
        :password, :password_confirmation, :current_password
      )
    end

    def load_content
      @pc = YAML.load_file(Rails.root.join('lib', 'data', 'content', "#{action_name}.yml"))[action_name.to_s]
    end

    def set_SEO_elements
      @page_title = 'Welcome to Your Personal Sleep Apnea Account'
      @page_content = 'Set your sleep apnea community profile, participate in sleep discussions, and join the MyApnea sleep study to help advance sleep apnea research.'
    end

end
