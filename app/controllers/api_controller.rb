class ApiController < ApplicationController

  # before_action :parse_request, only: [:vote]
  # before_action :authenticate_app_from_token!, only: [:vote]
  before_action :authenticate_user!, only: [:vote, :research_topic_create, :topic_create, :post_create]

  skip_before_action :verify_authenticity_token, only: [:vote, :research_topic_create, :topic_create, :post_create]

  # ## Users
  # def user_signup
  # end

  # def user_login
  # end

  ## Research Topics
  def research_topic_index
    @research_topics = ResearchTopic.approved
    respond_to do |format|
      format.json { @research_topics }
    end
  end

  def research_topic_show
    @research_topic = ResearchTopic.find(params[:research_topic_id])
  end

  def research_topic_create
    @new_research_topic = @user.research_topics.new(params.require(:research_topic).permit(:text, :description))
    if @new_research_topic.save
      respond_to do |format|
        format.json { @new_research_topic }
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
      format.json { @votes }
    end
  end

  def vote
    @research_topic = ResearchTopic.find(params[:research_topic_id])
    @vote_failed = false
    if params["endorse"].to_s == "1"
      @research_topic.endorse_by(@user, params["comment"])
    elsif params["endorse"].to_s == "0"
      @research_topic.oppose_by(@user, params["comment"])
    else
      @vote_failed = true
    end

    respond_to do |format|
      format.json { @vote_failed }
    end
  end


  # # Forums

  def topic_index
    @topics = Topic.current.not_research
    respond_to do |format|
      format.json { @topics }
    end
  end

  def topic_show
    @topic = Topic.find(params[:topic_id])
    @posts = @topic.posts.current
    respond_to do |format|
      format.json { @posts }
    end
  end

  def topic_create
    @topic = @user.topics.where(forum_id: params[:forum_id]).new(params.require(:topic).permit(:name, :description))
    if @topic.save
      respond_to do |format|
        format.json { @topic }
      end
    else
      respond_to do |format|
        format.json { @topic = nil }
      end
    end
  end

  def post_create
    @post = @user.posts.where(topic_id: params[:topic_id]).new(params.require(:post).permit(:description))
    if @post.save
      respond_to do |format|
        format.json { @post }
      end
    else
      respond_to do |format|
        format.json { @post = nil }
      end
    end
  end


  private

    def authenticate_user!
      unless params[:user_forum_name].present?
        render nothing: true, status: :unauthorized
      else
        unless @user = User.find_by_forum_name(params[:user_forum_name])
          render nothing: true, status: :bad_request
        end
      end
    end

    def authenticate_app_from_token!
      unless params['api_token'].present?
        render nothing: true, status: :unauthorized
      else
        if Devise.secure_compare(ENV['api_token'], params['api_token'])
          render nothing: true, status: :ok
        else
          render nothing: true, status: :unauthorized
        end
      end
    end

    # def parse_request
    #   @json = JSON.parse(request.body.read)
    # end


end
