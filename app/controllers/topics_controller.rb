# frozen_string_literal: true

# Allows users to view and create topics on the forum.
class TopicsController < ApplicationController
  before_action :authenticate_user!,      only: [:new, :create, :edit, :update, :destroy, :subscription]
  before_action :set_viewable_topic,      only: [:show, :subscription]
  before_action :set_editable_topic,      only: [:edit, :update]
  before_action :set_deletable_topic,     only: [:destroy]
  before_action :redirect_without_topic,  only: [:show, :edit, :update, :destroy, :subscription]

  # GET /forum/markup
  def markup
  end

  # POST /forum/my-first-topic/subscription.js
  def subscription
    @topic.set_subscription!(params[:notify].to_s == '1', current_user)
  end

  # GET /forum
  def index
    redirect_to chapters_path
  end

  # GET /forum/my-first-topic
  def show
    @topic.increase_views!(current_user)
  end

  # GET /forum/new
  def new
    @topic = current_user.topics.new
  end

  # GET /forum/my-first-topic/edit
  def edit
  end

  # POST /forum
  def create
    @topic = current_user.topics.new(topic_params)
    if @topic.save
      redirect_to @topic, notice: 'Topic was successfully created.'
    else
      render :new
    end
  end

  # PATCH /forum/my-first-topic
  def update
    if @topic.update(topic_params)
      redirect_to @topic, notice: 'Topic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /forum/my-first-topic
  def destroy
    @topic.destroy
    redirect_to topics_path, notice: 'Topic was successfully deleted.'
  end

  private

  def viewable_topics
    if current_user
      current_user.viewable_topics.not_research
    else
      Topic.current.not_research.where(status: %w(approved pending_review))
    end
  end

  def set_viewable_topic
    @topic = viewable_topics.find_by_slug params[:id]
  end

  def set_editable_topic
    @topic = current_user.editable_topics.find_by_slug params[:id]
  end

  def set_deletable_topic
    @topic = current_user.deletable_topics.find_by_slug params[:id]
  end

  def redirect_without_topic
    empty_response_or_root_path(topics_path) unless @topic
  end

  def topic_params
    if current_user.moderator?
      params.require(:topic).permit(:name, :description, :slug, :locked, :pinned, :status)
    else
      params.require(:topic).permit(:name, :description)
    end
  end
end
