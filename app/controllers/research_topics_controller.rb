class ResearchTopicsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_research_topic,      only: [:show, :edit, :update, :destroy]

  before_action :redirect_beginner,      only: [:newest, :most_discussed, :index, :show, :create, :my_research_topics]

  before_action :no_layout,                           only: [ :research_topics ]
  before_action :set_active_top_nav_link_to_research

  authorize_actions_for ResearchTopic, only: [:index, :create]

  def intro
  end

  def first_topics
    redirect_to intro_research_topics_path and return if current_user.no_votes_user? and params[:read_intro].blank?
    redirect_to research_topics_path and return if current_user.experienced_voter?

    @research_topic = current_user.seeded_research_topic
  end

  def newest
    @research_topics = ResearchTopic.approved.newest
  end

  def most_discussed
    @research_topics = ResearchTopic.approved.most_discussed
  end

  def my_research_topics
    @research_topics = current_user.my_research_topics
    @new_research_topic = ResearchTopic.new
  end

  def index
    @research_topics = ResearchTopic.approved
    @new_research_topic = ResearchTopic.new
  end

  def show
    @forum = Forum.for_research_topics
    @topic = @research_topic.topic
  end

  def edit
  end

  def create
    @new_research_topic = current_user.research_topics.new(research_topic_params)

    if @new_research_topic.save
      flash[:notice] = 'Topic was successfully created.'
      redirect_to research_topic_path(@new_research_topic)
    else
      @research_topics = ResearchTopic.approved
      render :index
    end

  end

  def update
    flash[:notice] = 'Research topic was successfully updated.' if @research_topic.update(params.require(:research_topic).permit(:progress))
    @forum = Forum.find_by_slug(ENV['research_topic_forum_slug'])
    @topic = @research_topic.topic
    render :show
  end

  def destroy
    @research_topic.destroy
    @research_topic.topic.destroy
    respond_to do |format|
      format.html { redirect_to research_topics_path }
      format.json { head :no_content }
    end
  end

  # Accepted research topics
  def sleep_apnea_body_weight
    render 'research_topics/accepted/sleep_apnea_body_weight'
  end

  def sleep_apnea_brain_plasticity
    render 'research_topics/accepted/sleep_apnea_brain_plasticity'
  end

  def sleep_apnea_adenotonsillectomy_children
    render 'research_topics/accepted/sleep_apnea_adenotonsillectomy_children'
  end

  # Voting

  def vote
    @research_topic = ResearchTopic.find(params[:research_topic_id])
    if current_user.experienced_voter? or @research_topic.seeded?
      if params["endorse_#{@research_topic.id}"].to_s == "1"
        @research_topic.endorse_by(current_user, params["comment_#{@research_topic.id}"])
      elsif params["endorse_#{@research_topic.id}"].to_s == "0"
        @research_topic.oppose_by(current_user, params["comment_#{@research_topic.id}"])
      else
        @vote_failed = true
        flash[:notice] = "Please either endorse or oppose this research topic."
      end

      respond_to do |format|
        format.html { redirect_to :back }
        format.js {  }
      end

    else
      render nothing: true
    end

  end

  def change_vote
    research_topic = ResearchTopic.find(params[:research_topic_id])
    current_user.endorsed?(research_topic) ? research_topic.oppose_by(current_user) : research_topic.endorse_by(current_user)
    redirect_to :back
  end

  private

  def redirect_beginner
    redirect_to intro_research_topics_path if current_user.no_votes_user?
    redirect_to first_topics_research_topics_path if current_user.novice_voter?
  end

  def set_research_topic
    @research_topic = ResearchTopic.find_by_slug(params[:id])
  end

  def research_topic_params
    params.require(:research_topic).permit(:text, :description)
  end
end
