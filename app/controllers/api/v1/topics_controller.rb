class Api::V1::TopicsController < ApplicationController
  before_action :authenticate_user!,              only: [:create]
  skip_before_action :verify_authenticity_token,  only: [:create]

  before_action :set_topic,                       only: [:show]
  before_action :redirect_without_topic,          only: [:show]

  respond_to :json

  def index
    @topics = Topic.current.viewable_by_user(current_user.present? ? current_user : nil).not_research.order(last_post_at: :desc, id: :desc).page(params[:page]).per(40)
  end

  def show
  end

  def create
    @topic = current_user.topics.where(forum_id: params[:forum_id]).new(topic_params)

    if @topic.save
      render action: 'show', status: :created, location: api_v1_topic_path(@topic)
    else
      render json: @topic.errors, status: :unprocessable_entity
    end
  end

  private

    def set_topic
      @topic = Topic.find_by_id params[:id]
    end

    def redirect_without_topic
      head :no_content unless @topic
    end

    def topic_params
      params.require(:topic).permit(:name, :description)
    end

end
