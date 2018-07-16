# frozen_string_literal: true

# Allows admins to manage user accounts.
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_report_manager, only: [:index]
  before_action :check_admin, except: [:index]
  before_action :find_user_or_redirect, only: [:show, :edit, :update, :spam, :destroy]

  layout "layouts/full_page_sidebar"

  # GET /users
  def index
    scope = User.current.search(params[:search], match_start: false)
    scope = scope.no_spammer_or_shadow_banned if current_user.report_manager?
    @users = scope_order(scope).page(params[:page]).per(40)
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

  # POST /users/1/spam.js
  def spam
    @user.update(shadow_banned: true, spammer: true)
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
      :profile_location, :profile_reviewed
    )
  end

  def check_admin_or_report_manager
    return if current_user && (current_user.admin? || current_user.report_manager?)
    redirect_to root_path
  end

  def scope_order(scope)
    @order = params[:order]
    scope.order(Arel.sql(User::ORDERS[params[:order]] || User::DEFAULT_ORDER))
  end
end
