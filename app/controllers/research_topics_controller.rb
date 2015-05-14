class ResearchTopicsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_research_topic,      only: [:show, :edit, :update, :destroy]

  before_action :no_layout,                           only: [ :research_topics ]
  before_action :set_active_top_nav_link_to_research

  authorize_actions_for ResearchTopic, only: [:index, :create]

  def intro
  end

  def first_topics
    redirect_to intro_research_topics_path and return if current_user.no_votes_user? and params[:read_intro].blank?
    redirect_to research_topics_path and return if current_user.experienced_voter?

    @research_topic = current_user.seeded_research_topic

    redirect_to newest_research_topics_path and return if @research_topic.blank?

  end

  # def discussion
  #   @forum = Forum.find_by_slug(ENV['research_topic_forum_slug'])
  # end

  def newest
    redirect_to intro_research_topics_path if current_user.no_votes_user?
    redirect_to first_topics_research_topics_path if current_user.novice_voter?

    @research_topics = ResearchTopic.approved.newest.to_a
  end

  def most_discussed
    redirect_to intro_research_topics_path if current_user.no_votes_user?
    redirect_to first_topics_research_topics_path if current_user.novice_voter?

    @research_topics = ResearchTopic.approved.most_discussed
  end

  def index
    if current_user.experienced_voter?
      @research_topics = ResearchTopic.approved
    else
      redirect_to current_user.no_votes_user? ? intro_research_topics_path : first_topics_research_topics_path
    end
  end

  def show
    @forum = Forum.find_by_slug(ENV['research_topic_forum_slug'])
    @topic = @research_topic.topic
  end

  def edit
  end

  def create
    redirect_to intro_research_topics_path and return if current_user.no_votes_user?
    redirect_to first_topics_research_topics_path and return if current_user.novice_voter?

    @new_research_topic = current_user.research_topics.new(research_topic_params)


    if @new_research_topic.save
      flash[:notice] = 'Topic was successfully created.'
      redirect_to research_topics_path
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

  def vote
    @research_topic = ResearchTopic.find(params[:research_topic_id])
    if current_user.experienced_voter? or @research_topic.seeded?
      params[:endorse].to_i == 1 ? @research_topic.endorse_by(current_user, params[:comment]) : @research_topic.oppose_by(current_user, params[:comment])
      redirect_to :back
    else
      render nothing: true
    end

  end

  private

  def set_research_topic
    @research_topic = ResearchTopic.find_by_slug(params[:id])
  end

  def research_topic_params
    params.require(:research_topic).permit(:text, :description)
  end
end
