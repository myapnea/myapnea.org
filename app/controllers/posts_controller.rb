# frozen_string_literal: true

# Allows users to view and modify forum posts.
class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :preview]
  before_action :set_topic
  before_action :redirect_without_topic
  # before_action :check_banned, only: [:create, :edit, :update]
  before_action :redirect_on_locked_topic, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show]
  before_action :set_editable_post, only: [:edit, :update]
  before_action :set_deletable_post, only: [:destroy]
  before_action :redirect_without_post, only: [:show, :edit, :update, :destroy]

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.where(topic_id: @topic.id).new(post_params)

    if @post.save
      @post.send_reply_emails!
      @topic.get_or_create_subscription(current_user)
      @topic.touch(:last_post_at)
      redirect_to topic_post_path(@topic, @post), notice: 'Post was successfully created.'
    else
      redirect_to topic_path(@topic, error: @errors)
    end
  end

  def preview
    @post = current_user.posts.where(topic_id: @topic.id).new(post_params)
  end

  def index
    redirect_to @topic
  end

  def show
    redirect_to topic_path(@topic, page: @post.page, anchor: @post.anchor)
  end

  # PATCH /posts/1
  def update
    if @post.update(post_params)
      redirect_to [@topic, @post], notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy_by_user(current_user)
    redirect_to [@topic, @post], notice: 'Post was successfully deleted.'
  end

  private

  def set_topic
    @topic = Topic.current.find_by_slug params[:topic_id]
  end

  def redirect_without_topic
    empty_response_or_root_path(topics_path) unless @topic
  end

  def redirect_on_locked_topic
    empty_response_or_root_path(@topic) if @topic.locked?
  end

  def set_post
    @post = @topic.posts.find_by_id params[:id]
  end

  def set_editable_post
    @post = current_user.editable_posts.with_unlocked_topic.where(topic_id: @topic.id).find_by_id(params[:id])
  end

  def set_deletable_post
    @post = current_user.deletable_posts.where(topic_id: @topic.id).find_by_id(params[:id])
  end

  def redirect_without_post
    empty_response_or_root_path(@topic) unless @post
  end

  def post_params
    params[:post] ||= { blank: '1' }
    # Always set post back to pending review if it's updated by a non-moderator
    params[:post][:status] = 'pending_review' unless current_user.moderator?
    if current_user.moderator?
      params.require(:post).permit(:description, :status, :links_enabled)
    else
      params.require(:post).permit(:description, :status)
    end
  end
end
