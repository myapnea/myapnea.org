class ForumsController < ApplicationController

  before_action :authenticate_user!,      only: [:new, :create, :edit, :update, :destroy]
  before_action :check_owner,             only: [:new, :create, :edit, :update, :destroy]
  before_action :set_active_top_nav_link_to_forums

  before_action :set_forum,               only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_forum,  only: [:show, :edit, :update, :destroy]

  before_action :check_approved_terms

  before_action :redirect_to_research_topic, only: [ :show ]

  before_action :set_SEO_elements

  respond_to :html

  def index
    @forums = Forum.current.main
    respond_with(@forums)
  end

  def show
    @forum.increase_views!(current_user)
    respond_with(@forum)
  end

  def new
    @forum = Forum.new(position: (Forum.count + 1) * 10)
    respond_with(@forum)
  end

  def edit
  end

  def create
    @forum = current_user.forums.new(forum_params)
    flash[:notice] = 'Forum was successfully created.' if @forum.save
    respond_with(@forum)
  end

  def update
    flash[:notice] = 'Forum was successfully updated.' if @forum.update(forum_params)
    respond_with(@forum)
  end

  def destroy
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.json { head :no_content }
    end
  end

  private
    def set_forum
      @forum = Forum.current.find_by_slug(params[:id])
    end

    def redirect_without_forum
      empty_response_or_root_path(forums_path) unless @forum
    end

    def redirect_to_research_topic
      redirect_to research_topics_path if @forum.slug==ENV['research_topic_forum_slug']
    end

    def forum_params
      params.require(:forum).permit(:name, :description, :slug, :position)
    end

    def check_approved_terms
      if current_user and (current_user.accepted_terms_conditions_at.blank? or current_user.accepted_terms_conditions_at < Date.parse(Forum::RECENT_FORUMS_UPDATE_DATE).at_noon) and (!@forum or (@forum and !@forum.for_research_topics?))
        session[:return_to] = request.fullpath
        redirect_to terms_and_conditions_path
      end
    end

    def set_SEO_elements
      @page_title = @forum.present? ? ('Sleep Apnea Forums - ' + @forum.name) : 'Sleep Apnea Community Area for Discussions'
      @page_content = 'Sleep apnea forums, discussions about treatments and CPAP machines, sleep deprivation symptoms, and more topics related to sleep apnea discussed on MyApnea.Org'
    end
end
