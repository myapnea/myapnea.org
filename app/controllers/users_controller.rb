# frozen_string_literal: true

# Allows admins to manage user accounts.
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_user_or_redirect, only: [:show, :edit, :update, :destroy]

  layout 'application_padded'

  # GET /users
  def index
    @all_users = User.current.search(params[:search]).order(current_sign_in_at: :desc)
    @order = scrub_order(User, params[:order], 'current_sign_in_at desc')
    @order = params[:order] if ['reply_count', 'reply_count desc'].include?(params[:order])
    @users = @all_users.reply_count.reorder(@order).page(params[:page]).per(40)
  end

  # GET /users/export
  def export
    @csv_string = CSV.generate do |csv|
      csv << [
        'MyApnea ID', 'Email', 'First Name', 'Last Name', 'Number of Surveys Completed',
        'Last Login', 'Login Count', 'Forum Posts', 'First Forum Post',
        'Last Forum Post'
      ]
      User.current.find_each do |user|
        first_reply = user.replies.order(:created_at).first
        last_reply = user.replies.order(:created_at).last
        row = [
          user.myapnea_id,
          user.email,
          user.first_name,
          user.last_name,
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
    filename = "myapnea-users-#{Time.zone.now.strftime('%Y-%m-%d-%Ih%M-%p')}.csv"
    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"#{filename}\""
  end

  # GET /users/1/edit
  # def edit
  # end

  # PATCH /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.js
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully deleted.' }
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
      :first_name, :last_name, :email, :forum_name, :emails_enabled,
      :include_in_exports, :admin, :moderator, :community_contributor,
      :can_build_surveys, :shadow_banned
    )
  end
end
