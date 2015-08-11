class Api::V1::ResearchTopicsController < ApplicationController

  before_action :authenticate_user!,                       only: [:create, :vote]
  skip_before_action :verify_authenticity_token,           only: [:create, :vote]

  before_action :set_research_topic,                       only: [:show, :vote]
  before_action :redirect_without_research_topic,          only: [:show, :vote]

  respond_to :json

  def index
    @research_topics = ResearchTopic.approved
  end

  def show
  end

  def create
    @research_topic = current_user.research_topics.new(research_topic_params)
    if @research_topic.save
      render action: 'show', status: :created, location: api_v1_research_topic_path(@research_topic)
    else
      render json: @research_topic.errors, status: :unprocessable_entity
    end
  end

  def vote
    @vote_failed = true
    if params["endorse"].to_s == "1"
      @research_topic.endorse_by(current_user, params["comment"])
      @vote_failed = false
    elsif params["endorse"].to_s == "0"
      @research_topic.oppose_by(current_user, params["comment"])
      @vote_failed = false
    end
  end


  private

    def set_research_topic
      @research_topic = ResearchTopic.find_by_id params[:id]
    end

    def redirect_without_research_topic
      head :no_content unless @research_topic
    end

    def research_topic_params
      params.require(:research_topic).permit(:text, :description)
    end

end
