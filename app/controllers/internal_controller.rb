# frozen_string_literal: true

# Displays internal dashboards and user specific pages.
class InternalController < ApplicationController
  before_action :authenticate_user!

  layout 'application_padded'

  # GET /dashboard
  def dashboard
    redirect_to dashboard3_path
  end

  # # GET /dashboard1
  # def dashboard1
  # end

  # # GET /dashboard2
  # def dashboard2
  # end

  # # GET /dashboard3
  # def dashboard3
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
