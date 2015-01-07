class TopicsController < ApplicationController

  before_action :authenticate_user!,      only: [ :new, :create, :edit, :update, :destroy, :admin, :subscription ]

  before_action :check_system_admin,      only: [ :destroy, :admin ] # Perhaps check moderator


  before_action :set_viewable_forum,      only: [ :show, :index ]
  before_action :redirect_without_forum,  only: [ :show, :index ]

  before_action :set_viewable_topic,      only: [ :show, :destroy, :admin, :subscription ]
  before_action :set_editable_topic,      only: [ :edit, :update ]

  before_action :redirect_without_topic,  only: [ :show, :edit, :update, :destroy, :subscription ]

  respond_to :html

  # TODO remove when new layout is default
  layout 'layouts/cleantheme'

  def admin
    @topic.update(topic_admin_params)
    redirect_to topics_path
  end

  def index
    redirect_to forums_path + '/' + @forum.to_param
    # redirect_to @forum
  end

  def show
    respond_with(@topic)
  end

  def new
    @topic = Topic.new
    respond_with(@topic)
  end

  # def edit
  # end

  # def create
  #   @topic = Topic.new(topic_params)
  #   flash[:notice] = 'Topic was successfully created.' if @topic.save
  #   respond_with(@topic)
  # end

  # def update
  #   flash[:notice] = 'Topic was successfully updated.' if @topic.update(topic_params)
  #   respond_with(@topic)
  # end

  # def destroy
  #   @topic.destroy
  #   respond_to do |format|
  #     format.html { redirect_to @forum }
  #     format.json { head :no_content }
  #   end
  # end

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
      @topic = current_user.all_topics.where( locked: false ).find_by_slug(params[:id])
    end

    def redirect_without_topic
      empty_response_or_root_path(@forum) unless @topic
    end

    def topic_params
      params.require(:topic).permit(:forum_id, :user_id, :name, :locked, :pinned, :last_post_at, :state, :views_count, :slug)
    end

    def topic_params
      params.require(:topic).permit(:forum_id, :name, :description)
    end

    def topic_admin_params
      params.require(:topic).permit(:locked, :pinned, :state)
    end

end
