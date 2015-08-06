class ApiController < ApplicationController

  AUTHENTICATE_ACTIONS = [:home, :survey_answer_sessions, :vote, :research_topic_create, :topic_create, :post_create]

  before_action :authenticate_user!, only: AUTHENTICATE_ACTIONS
  skip_before_action :verify_authenticity_token, only: AUTHENTICATE_ACTIONS


  def home
    render json: { name: current_user.email }
  end

  ## Surveys
  def survey_answer_sessions
    @answer_sessions = current_user.answer_sessions
    respond_to do |format|
      format.json
    end
  end

  ## Research Topics
  def research_topic_index
    @research_topics = ResearchTopic.approved
    respond_to do |format|
      format.json
    end
  end

  def research_topic_show
    @research_topic = ResearchTopic.find(params[:research_topic_id])
  end

  def research_topic_create
    @new_research_topic = current_user.research_topics.new(params.require(:research_topic).permit(:text, :description))
    if @new_research_topic.save
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json { @new_research_topic = nil }
      end
    end
  end

  def votes
    @votes = Vote.current
    if params[:user].present? and User.find_by_forum_name(params[:user]).present?
      @votes = @votes.where(user_id: User.find_by_forum_name(params[:user]).id)
    end
    if params[:rating].present?
      @votes = @votes.where(rating: params[:rating].to_i)
    end
    if params[:research_topic_id].present?
      @votes = @votes.where(research_topic_id: params[:research_topic_id].to_i)
    end
    respond_to do |format|
      format.json
    end
  end

  def vote
    @vote_failed = true
    if params[:research_topic_id].present? and @research_topic = ResearchTopic.find(params[:research_topic_id])
      if params["endorse"].to_s == "1"
        @research_topic.endorse_by(current_user, params["comment"])
        @vote_failed = false
      elsif params["endorse"].to_s == "0"
        @research_topic.oppose_by(current_user, params["comment"])
        @vote_failed = false
      end
    end

    respond_to do |format|
      format.json
    end
  end


  # # Forums

  def topic_index
    @topics = Topic.current.viewable_by_user(current_user.present? ? current_user : nil).not_research.order(last_post_at: :desc, id: :desc)
    respond_to do |format|
      format.json
    end
  end

  def topic_show
    @topic = Topic.find(params[:topic_id])
    @posts = @topic.posts.current
    respond_to do |format|
      format.json
    end
  end

  def topic_create
    @topic = current_user.topics.where(forum_id: params[:forum_id]).new(params.require(:topic).permit(:name, :description))
    if @topic.save
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json { @topic = nil }
      end
    end
  end

  def post_create
    @post = current_user.posts.where(topic_id: params[:topic_id]).new(params.require(:post).permit(:description))
    if @post.save
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json { @post = nil }
      end
    end
  end


  private

    # def parse_request
    #   @json = JSON.parse(request.body.read)
    # end


end
