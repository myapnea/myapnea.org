class ApiController < ApplicationController

  before_action :parse_request, only: [:vote]
  before_action :authenticate_app_from_token!, only: [:vote]
  before_action :authenticate_user!, only: [:vote]

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

  def votes
    @votes = Vote.current
    if params[:user_id].present?
      @votes = @votes.where(user_id: params[:user_id].to_i)
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
  end


  private

    def authenticate_user!
      if !@json['user_id']
        render nothing: true, status: :unauthorized
      else
        if @user = User.find(@json['user_id'])
          render nothing: true, status: :ok
        else
          render nothing: true, status: :bad_request
        end
      end
    end

    def authenticate_app_from_token!
      if !@json['api_token']
        render nothing: true, status: :unauthorized
      else
        if Devise.secure_compare(ENV['api_token'], @json['api_token'])
          render nothing: true, status: :ok
        else
          render nothing: true, status: :unauthorized
        end
      end
    end

    def parse_request
      @json = JSON.parse(request.body.read)
    end


end
