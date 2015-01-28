class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner_or_moderator

  def research_topics
    @research_topics = ResearchTopic.all.order("created_at desc")
  end

  def research_topic
    @research_topic = ResearchTopic.find(params[:id])
  end

  def surveys

  end

  def notifications
    @posts = Notification.notifications
    @new_post = Notification.new(post_type: :notification)
  end

end
