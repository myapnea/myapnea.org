# frozen_string_literal: true

# Displays internal dashboards and user specific pages.
class InternalController < ApplicationController
  before_action :authenticate_user!

  layout 'application_padded'

  # # GET /dashboard
  # def dashboard
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
