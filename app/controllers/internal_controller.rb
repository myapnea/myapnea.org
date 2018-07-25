# frozen_string_literal: true

# Displays internal dashboards and user specific pages.
class InternalController < ApplicationController
  before_action :authenticate_user!

  # # GET /dashboard
  # def dashboard
  # end

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
