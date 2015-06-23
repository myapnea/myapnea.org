class TopicsController < ApplicationController

  before_action :authenticate_user!,      only: [ :new, :create, :edit, :update, :destroy, :subscription ]
  before_action :set_active_top_nav_link_to_forums

  before_action :set_viewable_forum
  before_action :redirect_without_forum

  before_action :check_approved_terms

  before_action :set_viewable_topic,      only: [ :show, :subscription ]
  before_action :set_editable_topic,      only: [ :edit, :update ]
  before_action :set_deletable_topic,     only: [ :destroy ]

  before_action :redirect_without_topic,  only: [ :show, :edit, :update, :destroy, :subscription ]

  before_action :redirect_to_research_topic, only: [ :show ]

  before_action :set_SEO_elements

  respond_to :html

  def subscription
    @topic.set_subscription!(params[:notify].to_s == '1', current_user)
    redirect_to [@forum, @topic]
  end

  def index
    redirect_to @forum
  end

  def show
    @topic.increase_views!(current_user)
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
      format.html { redirect_to @forum, notice: 'Topic was successfully deleted.' }
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
      @topic = if current_user
        current_user.viewable_topics.where(forum_id: @forum.id).find_by_slug(params[:id])
      else
        @forum.topics.viewable_by_user(current_user ? current_user.id : nil).find_by_slug(params[:id])
      end
    end

    def set_editable_topic
      @topic = current_user.editable_topics.where(forum_id: @forum.id).find_by_slug(params[:id])
    end

    def set_deletable_topic
      @topic = current_user.deletable_topics.where(forum_id: @forum.id).find_by_slug(params[:id])
    end

    def redirect_without_topic
      empty_response_or_root_path(@forum) unless @topic
    end

    def redirect_to_research_topic
      redirect_to research_topic_path(@topic.research_topic) if @topic.research_topic.present?
    end

    def topic_params
      if current_user.moderator?
        params.require(:topic).permit(:name, :description, :slug, :locked, :pinned, :status, :forum_id)
      else
        params.require(:topic).permit(:name, :description)
      end
    end

    def check_approved_terms
      if current_user and !@forum.for_research_topics? and (current_user.accepted_terms_conditions_at.blank? or current_user.accepted_terms_conditions_at < Date.parse(Forum::RECENT_FORUMS_UPDATE_DATE).at_noon)
        session[:return_to] = request.fullpath
        redirect_to terms_and_conditions_path
      end
    end

    def set_SEO_elements
      @page_title = @topic.present? ? @topic.name : ('Sleep Apnea ' + @forum.name + ' Community Discussions')
      @page_content = 'Sleep apnea forums, discussions about treatments and CPAP machines, sleep deprivation symptoms, and more topics related to sleep apnea discussed on MyApnea.Org'
    end

end
