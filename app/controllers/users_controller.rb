# frozen_string_literal: true

# Allows admins to manage user accounts.
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_report_manager, only: [:index]
  before_action :check_admin, except: [:index]
  before_action :find_user_or_redirect, only: [:show, :edit, :update, :destroy]

  layout "layouts/full_page_sidebar"

  # GET /users
  def index
    user_scope = User.current.search(params[:search])
    @order = scrub_order(User, params[:order], Arel.sql("(CASE WHEN (users.current_sign_in_at IS NULL) THEN users.created_at ELSE users.current_sign_in_at END) desc"))
    @order = params[:order] if ["reply_count", "reply_count desc"].include?(params[:order])
    user_scope = user_scope.no_spammer_or_shadow_banned if current_user.report_manager?
    @users = user_scope.reply_count.order(@order).page(params[:page]).per(40)
  end

  # GET /users/export
  def export
    @csv_string = CSV.generate do |csv|
      csv << [
        "MyApnea ID", "Email", "Full Name", "Number of Surveys Completed",
        "Last Login", "Login Count", "Forum Posts", "First Forum Post",
        "Last Forum Post"
      ]
      User.current.find_each do |user|
        first_reply = user.replies.order(:created_at).first
        last_reply = user.replies.order(:created_at).last
        row = [
          user.myapnea_id,
          user.email,
          user.full_name,
          -1,
          (user.current_sign_in_at ? user.current_sign_in_at.to_date : nil),
          user.sign_in_count,
          user.replies.count,
          (first_reply ? first_reply.created_at.to_date : nil),
          (last_reply ? last_reply.created_at.to_date : nil)
        ]
        csv << row
      end
    end
    filename = "myapnea-users-#{Time.zone.now.strftime("%Y-%m-%d-%Ih%M-%p")}.csv"
    send_data @csv_string, type: "text/csv; charset=iso-8859-1; header=present",
                           disposition: "attachment; filename=\"#{filename}\""
  end

  # GET /users/1/edit
  # def edit
  # end

  # PATCH /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.js
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully deleted." }
      format.js
    end
  end

  private

  def find_user_or_redirect
    @user = User.current.find_by(id: params[:id])
    redirect_without_user
  end

  def redirect_without_user
    empty_response_or_root_path(users_path) unless @user
  end

  def user_params
    params.require(:user).permit(
      :full_name, :email, :username, :emails_enabled,
      :include_in_exports, :admin, :moderator, :community_contributor,
      :shadow_banned, :spammer, :content_manager, :report_manager, :profile_bio,
      :profile_location
    )
  end

  def check_admin_or_report_manager
    return if current_user && (current_user.admin? || current_user.report_manager?)
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page."
  end
end
