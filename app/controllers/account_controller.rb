# frozen_string_literal: true

# Allows members to update their account settings.
class AccountController < ApplicationController
  before_action :authenticate_user!

  ## Methods for consent, privacy, and terms of access

  def accepts_privacy
    current_user.update accepted_privacy_policy_at: Time.zone.now
    not_ready_path = current_user.is_only_researcher? ? terms_of_access_path : consent_path
    redirect_to current_user.ready_for_research? ? surveys_path : not_ready_path
  end

  def accepts_consent
    current_user.accepts_consent!
    redirect_to current_user.ready_for_research? ? surveys_path : privacy_path
  end

  def accepts_terms_of_access
    current_user.accepts_terms_of_access!
    redirect_to current_user.ready_for_research? ? surveys_path : privacy_path
  end

  def accepts_update
    if current_user.is_only_researcher?
      current_user.accepts_terms_of_access!
    else
      current_user.accepts_consent!
    end
    redirect_to (session[:return_to] || root_path)
  end

  def accepts_terms_and_conditions
    current_user.update(accepted_terms_conditions_at: Time.zone.now)
    redirect_to session[:return_to] || topics_path
  end

  def revoke_consent
    current_user.revoke_consent!
    redirect_to root_path, notice: 'You have successfully left the research study portion of MyApnea.Org. If you ever change your mind, just visit your account settings to view the research consent and privacy policy again.'
  end

  # def dashboard
  # end

  # def account
  # end

  def update
    if current_user.update(user_params)
      respond_to do |format|
        format.js
        format.all { redirect_to account_path, notice: 'Your account settings have been successfully changed.' }
      end
    else
      render :account
    end
  end

  def change_password
    if current_user.update_with_password(user_password_params)
      # Sign in the user by passing validation in case the user's password changed
      bypass_sign_in current_user
      redirect_to account_path, notice: 'Your password has been changed.'
    else
      render :account
    end
  end

  def suggest_random_forum_name
    @new_forum_name = User.generate_forum_name(Time.zone.now.nsec.to_s)
  end

  # DELETE /account
  def destroy
    current_user.destroy
    sign_out current_user
    redirect_to landing_path, notice: 'Your account has been deleted.'
  end

  private

  def user_params
    params[:user] ||= { blank: '1' }
    params[:user][:user_is_updating] = '1'
    params.required(:user).permit(
      # Basic Information
      :first_name, :last_name, :email,
      # Forum and Social Profile
      :photo, :remove_photo, :forum_name, :experience, :device,
      # Receiving Emails
      :emails_enabled,
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
end
