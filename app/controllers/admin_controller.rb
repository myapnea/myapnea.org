# frozen_string_literal: true

# Allows admins to view admin dashboard and reports.
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_moderator

  # def dashboard
  # end

  # GET /admin/spam-inbox
  def spam_inbox
    @spammers = spammers
  end

  # POST /admin/unshadowban/:id
  def unshadowban
    member = spammers.find_by(id: params[:id])
    if member
      member.update(shadow_banned: false)
      flash[:notice] = "Member un-shadowbanned successfully."
    end
    redirect_to admin_spam_inbox_path
  end

  # POST /admin/empty-spam
  def empty_spam
    Topic.current.where(user: spammers).destroy_all
    spammers.destroy_all
    redirect_to admin_spam_inbox_path, notice: "All spammers have been deleted."
  end

  def unlock_survey
    @user = User.current.find_by(id: params[:user_id])
    answer_session = @user.answer_sessions.find_by(id: params[:answer_session_id]) if @user
    if answer_session
      flash[:notice] = 'Survey unlocked successfully.'
      answer_session.unlock!
    end
    redirect_to @user || users_path
  end

  def timeline
    @first_month = Date.parse("2014-10-01")
  end

  private

  def spammers
    User.current.where(shadow_banned: true)
  end
end
