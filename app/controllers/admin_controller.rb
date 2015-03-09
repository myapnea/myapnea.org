class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner_or_moderator

  def dashboard
  end

  def research_topics
    @research_topics = ResearchTopic.all.order("created_at desc")
  end

  def research_topic
    @research_topic = ResearchTopic.find(params[:id])
  end

  def surveys
  end

  def version_stats
    @version_dates = [
      { version: '5.0.0', release_date: Date.parse('2015-03-04'), next_release_date: nil },
      { version: '4.2.0', release_date: Date.parse('2015-01-29'), next_release_date: Date.parse('2015-03-04') },
      { version: '4.1.0', release_date: Date.parse('2015-01-21'), next_release_date: Date.parse('2015-01-29') },
      { version: '4.0.0', release_date: Date.parse('2015-01-15'), next_release_date: Date.parse('2015-01-21') },
      { version: 'Before 4.0.0', release_date: nil, next_release_date: Date.parse('2015-01-15') }
    ]
  end

  def notifications
    @posts = Notification.notifications
    @new_post = Notification.new(post_type: :notification)
  end

end
