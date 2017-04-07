# frozen_string_literal: true

# Forum topics with replies and votes.
class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_viewable_topic_or_redirect, only: [:show]
  before_action :find_editable_topic_or_redirect, only: [:edit, :update, :destroy]
  # before_action :redirect_shadow_banned_users, only: [:create]

  layout 'application-padded'

  # GET /topics
  def index
    @order = scrub_order(Topic, params[:order], 'pinned desc, last_reply_at desc, id desc')
    if ['reply_count', 'reply_count desc'].include?(params[:order])
      @order = params[:order]
    end
    topic_scope = Topic.current.reply_count.order(@order)
    topic_scope = topic_scope.shadow_banned(current_user ? current_user.id : nil) unless current_user && current_user.admin?
    @topics = topic_scope.page(params[:page]).per(40)
  end

  # GET /topics/1
  def show
    @page = (params[:page].to_i > 1 ? params[:page].to_i : 1)
    reply_scope = @topic.replies.includes(:topic).where(reply_id: nil).page(@page).per(Reply::REPLIES_PER_PAGE)
    last_reply_id = reply_scope.last.id
    reply_scope = reply_scope.shadow_banned(current_user ? current_user.id : nil) unless current_user && current_user.admin?
    @replies = reply_scope
    @topic.increment! :view_count
    current_user.read_parent!(@topic, last_reply_id) if current_user
  end

  # GET /topics/new
  def new
    @topic = current_user.topics.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  def create
    @topic = current_user.topics.new(topic_params)
    if @topic.save
      @topic.touch(:last_reply_at)
      @topic.compute_shadow_ban!
      redirect_to @topic, notice: 'Topic was successfully created.'
    else
      render :new
    end
  end

  # PATCH /topics/1
  def update
    if @topic.update(topic_params)
      @topic.compute_shadow_ban!
      redirect_to @topic, notice: 'Topic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /topics/1
  def destroy
    @topic.destroy
    redirect_to topics_path, notice: 'Topic was successfully deleted.'
  end

  private

  def viewable_topics
    Topic.current
  end

  def find_viewable_topic_or_redirect
    @topic = viewable_topics.find_by_slug params[:id]
    redirect_without_topic
  end

  def find_editable_topic_or_redirect
    @topic = current_user.editable_topics.find_by_slug params[:id]
    redirect_without_topic
  end

  def redirect_without_topic
    empty_response_or_root_path(topics_path) unless @topic
  end

  # def redirect_shadow_banned_users
  #   redirect_to topics_path, notice: 'Topic was successfully created.' if current_user.shadow_banned?
  # end

  def topic_params
    if current_user.moderator?
      params.require(:topic).permit(:title, :slug, :description, :pinned)
    else
      params.require(:topic).permit(:title, :slug, :description)
    end
  end
end
