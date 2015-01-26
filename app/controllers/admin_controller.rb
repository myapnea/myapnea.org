class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  authorize_actions_for User, only: [:add_role_to_user, :remove_role_from_user, :destroy_user, :users, :export_users], actions: { add_role_to_user: :update, remove_role_from_user: :update, destroy_user: :delete, users: :read, export_users: :read }

  # ## Remote Actions
  # def add_role_to_user
  #   User.find(params[:user_id]).add_role params[:role]


  #   set_users

  #   render "update_users"
  # end

  # def remove_role_from_user
  #   User.find(params[:user_id]).remove_role params[:role]

  #   set_users

  #   render "update_users"
  # end

  def research_topics
    @research_topics = ResearchTopic.all.order("created_at desc")
  end

  def research_topic
    @research_topic = ResearchTopic.find(params[:id])
  end

  def surveys

  end

  def notifications
    @posts = Notification.notifications
    @new_post = Notification.new(post_type: :notification)
  end


  private

  def authenticate_admin
    raise Authority::SecurityViolation.new(current_user, 'administrate', action_name) unless current_user.can?(:view_admin_dashboard)
  end

  def set_users
    @users = User.scoped_users(params[:search], params[:search_role])
  end


end
