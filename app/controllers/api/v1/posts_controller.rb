class Api::V1::PostsController < ApplicationController

  before_action :authenticate_user!,              only: [:create]
  skip_before_action :verify_authenticity_token,  only: [:create]

  before_action :set_topic,                       only: [:create]
  before_action :redirect_without_topic,          only: [:create]

  respond_to :json

  def show
  end

  def create
    @post = current_user.posts.where(topic_id: @topic.id).new(post_params)
    if @post.save
      render action: 'show', status: :created, location: api_v1_topic_post_path(@topic, @post)
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private

    def set_topic
      @topic = Topic.find_by_id params[:topic_id]
    end

    def redirect_without_topic
      head :no_content unless @topic
    end

    def post_params
      params.require(:post).permit(:description)
    end

end
