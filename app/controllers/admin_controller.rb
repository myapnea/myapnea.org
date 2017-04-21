# frozen_string_literal: true

# Allows admins to view admin dashboard and reports.
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_moderator

  # def dashboard
  # end

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
    @first_month = Date.parse('2014-10-01')
  end

  # def ages
  # end
end
