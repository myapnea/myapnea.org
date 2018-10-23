# frozen_string_literal: true

# Forum topics with replies and votes.
class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :subscription]
  before_action :find_viewable_topic_or_redirect, only: [:show, :subscription]
  before_action :find_editable_topic_or_redirect, only: [:edit, :update, :destroy]

  # POST /forum/my-first-topic/subscription.js
  def subscription
    @topic.set_subscription!(params[:notify].to_s == "1", current_user)
  end

  # GET /forum
  def index
    scope = Topic.current
    scope = scope.shadow_banned(current_user&.id) unless current_user&.admin?
    @topics = scope_order(scope).page(params[:page]).per(40)
  end

  # GET /forum/1
  def show
    @page = (params[:page].to_i > 1 ? params[:page].to_i : 1)
    reply_scope = @topic.replies.includes(:topic).where(reply_id: nil).page(@page).per(Reply::REPLIES_PER_PAGE)
    last_reply_id = reply_scope.last&.id
    reply_scope = reply_scope.shadow_banned(current_user) unless current_user && current_user.admin?
    @replies = reply_scope
    @topic.increment!(:view_count) if !current_user || (current_user && !current_user.shadow_banned?)
    current_user.read_parent!(@topic, last_reply_id) if current_user && last_reply_id
  end

  # GET /forum/new
  def new
    @topic = current_user.topics.new
  end

  # # GET /forum/1/edit
  # def edit
  # end

  # POST /forum
  def create
    @topic = current_user.topics.new(topic_params)
    if @topic.save
      @topic.touch(:last_reply_at)
      @topic.compute_shadow_ban!
      @topic.generate_automatic_subscriptions! unless @topic.user.shadow_banned?
      redirect_to @topic, notice: "Topic was successfully created."
    else
      render :new
    end
  end

  # PATCH /forum/1
  def update
    if @topic.update(topic_params)
      @topic.compute_shadow_ban!
      redirect_to @topic, notice: "Topic was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /forum/1
  def destroy
    @topic.destroy
    redirect_to topics_path, notice: "Topic was successfully deleted."
  end

  private

  def viewable_topics
    Topic.current
  end

  def find_viewable_topic_or_redirect
    @topic = viewable_topics.find_by_param(params[:id])
    redirect_without_topic
  end

  def find_editable_topic_or_redirect
    @topic = current_user.editable_topics.find_by_param(params[:id])
    redirect_without_topic
  end

  def redirect_without_topic
    empty_response_or_root_path(topics_path) unless @topic
  end

  def topic_params
    if current_user.moderator?
      params.require(:topic).permit(
        :title, :slug, :description, :pinned, :locked
      )
    else
      params.require(:topic).permit(:title, :slug, :description)
    end
  end

  def scope_order(scope)
    @order = params[:order]
    scope.order(Arel.sql(Topic::ORDERS[params[:order]] || Topic::DEFAULT_ORDER))
  end
end
