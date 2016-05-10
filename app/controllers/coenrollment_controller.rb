# frozen_string_literal: true

# Control flow for users linking MyApnea.Org account to Health eHeart account
# and vice versa.
class CoenrollmentController < ApplicationController
  before_action :authenticate_user!, except: [:welcome_health_eheart_members]

  # Intermediate splash page to allow users the option to go visit Health eHeart
  def join_health_eheart
  end

  # Flags the user as having visited Health eHeart
  def goto_health_eheart
    current_user.update outgoing_heh_at: Time.zone.now
    redirect_to current_user.heh_referral_url
  end

  # Public welcome page for Health eHeart members that sets the Health eHeart
  # incoming token that
  def welcome_health_eheart_members
    return if params[:incoming_heh_token].blank? && !current_user
    session[:incoming_heh_token] = params[:incoming_heh_token]
    if current_user
      redirect_to link_health_eheart_member_path
    else
      redirect_to welcome_health_eheart_members_path
    end
  end

  # Redirect link that updates a users Health eHeart incoming token that was
  # specified earlier when the first visited the welcome page
  def link_health_eheart_member
    if session[:incoming_heh_token].present? && current_user.update(health_eheart_params)
      redirect_to congratulations_health_eheart_members_path
    else
      redirect_to dashboard_path
    end
  end

  # Congratulations page for Health eHeart members linking their account to
  # their MyApnea.Org account
  def congratulations_health_eheart_members
  end

  # Remove incoming_heh_token, and outgoing_heh_at. The outgoing_heh_at is used
  # to clear the messaging to its initial state, and we KEEP incoming_heh_at to
  # track how many were linked from HeH, but then removed the coenrollment link.
  def remove_health_eheart
    current_user.update incoming_heh_token: nil, outgoing_heh_at: nil
    redirect_to account_path, notice: 'Your account is no longer linked to Health eHeart'
  end

  private

  def health_eheart_params
    { incoming_heh_token: session.delete(:incoming_heh_token),
      incoming_heh_at: Time.zone.now }
  end
end
