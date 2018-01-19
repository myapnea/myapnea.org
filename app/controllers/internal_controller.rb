# frozen_string_literal: true

# Displays internal dashboards and user specific pages.
class InternalController < ApplicationController
  before_action :authenticate_user!

  # GET /dashboard
  def dashboard
    # render layout: "layouts/full_page_sidebar_drawer"
  end

  # # GET /dashboard/research
  # def research
  # end

  # # GET /dashboard/reports
  # def reports
  # end

  # # GET /yoga/consent
  # def yoga_consent
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

  # # GET /settings/account
  # def settings_account
  # end

  # # GET /settings/consents
  # def settings_consents
  # end

  # # GET /settings/profile
  # def settings_profile
  # end
end
