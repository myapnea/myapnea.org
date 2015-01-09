class ResearchController < ApplicationController
  before_action :authenticate_user!, :only => [:research_karma, :research_surveys]
  before_action :set_active_top_nav_link_to_surveys
  before_action :authenticate_research, only: [:research_surveys]


  before_action :fetch_notifications

  layout "main"

  def fetch_notifications
    @posts = Notification.notifications.viewable.all
  end


end
