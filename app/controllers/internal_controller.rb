# frozen_string_literal: true

# Displays internal dashboards and user specific pages.
class InternalController < ApplicationController
  before_action :authenticate_user!

  layout "layouts/full_page_sidebar"

  # GET /dashboard
  def dashboard
    @replies = Reply.current
      .left_outer_joins(:broadcast, :topic)
      .where(topics: { id: Topic.current })
      .or(
        Reply.current
        .left_outer_joins(:broadcast, :topic)
        .where(broadcasts: { id: Broadcast.published })
      )
      .shadow_banned(current_user).order(created_at: :desc).limit(30)
  end

  # # GET /dashboard/reports
  # def reports
  # end

  # # GET /timeline
  # def timeline
  # end

  # # GET /research
  # def research
  # end

  # GET /settings
  def settings
    redirect_to settings_profile_path
  end
end
