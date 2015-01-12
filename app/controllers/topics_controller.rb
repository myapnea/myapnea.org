class TopicsController < ApplicationController

  before_action :authenticate_user!,      only: [ :new, :create, :edit, :update, :destroy, :moderate, :subscription ]
  before_action :check_moderator,         only: [ :moderate ]

  before_action :set_viewable_forum
  before_action :redirect_without_forum

  before_action :set_viewable_topic,      only: [ :show, :destroy, :moderate, :subscription ]
  before_action :set_editable_topic,      only: [ :edit, :update, :destroy ]

  before_action :redirect_without_topic,  only: [ :show, :edit, :update, :destroy, :subscription ]

  respond_to :html

  # TODO remove when new layout is default
  layout 'layouts/cleantheme'

  def moderate
    @topic.update(topic_params)
    redirect_to topics_path
  end

  def index
    redirect_to @forum
  end

  def show
    respond_with(@topic)
  end

  def new
    @topic = current_user.topics.where(forum_id: @forum.id).new
    respond_with(@forum, @topic)
  end

  def edit
  end

  def create
    @topic = current_user.topics.where(forum_id: @forum.id).new(topic_params)
    flash[:notice] = 'Topic was successfully created.' if @topic.save
    respond_with(@forum, @topic)
  end

  def update
    flash[:notice] = 'Topic was successfully updated.' if @topic.update(topic_params)
    respond_with(@forum, @topic)
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to @forum }
      format.json { head :no_content }
    end
  end

  private

    def set_viewable_forum
      @forum = Forum.current.find_by_slug(params[:forum_id])
    end

    def redirect_without_forum
      empty_response_or_root_path(forums_path) unless @forum
    end

    def set_viewable_topic
      # @topic = Topic.current.not_banned.find_by_slug(params[:id])
      @topic = @forum.topics.find_by_slug(params[:id])
    end

    def set_editable_topic
      # @topic = current_user.all_topics.not_banned.where( locked: false ).find_by_slug(params[:id])
      @topic = current_user.all_topics.where(forum_id: @forum.id).find_by_slug(params[:id])
    end

    def redirect_without_topic
      empty_response_or_root_path(@forum) unless @topic
    end

    def topic_params
      if current_user.has_role? :moderator
        params.require(:topic).permit(:name, :description, :hidden, :locked, :pinned, :status)
      else
        params.require(:topic).permit(:name, :description)
      end
    end

end
