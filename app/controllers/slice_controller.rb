# frozen_string_literal: true

# Allows users to access Slice surveys.
class SliceController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_project_or_redirect, only: [
    :consent, :enrollment_consent, :enrollment_exit
  ]

  layout "layouts/full_page_sidebar"

  # GET /surveys
  def surveys
    redirect_to slice_research_path unless current_user
  end

  # GET /research
  def research
    render layout: "layouts/application"
  end

  # # GET /research/:project/consent
  # def consent
  # end

  # POST /research/:project/consent
  def enrollment_consent
    if current_user
      current_user.consent!(@project)
      redirect_to slice_surveys_path(@project), notice: "Welcome to the study!"
    else
      session[:project_id] = @project.id
      session[:consented_at] = Time.zone.now
      redirect_to new_user_registration_path
    end
  end

  # GET /research/:project/exit
  def enrollment_exit
    session[:project_id] = nil
    session[:consented_at] = nil
    session[:consents] = nil
    redirect_to slice_research_path
  end

  private

  def find_project_or_redirect
    @project = Project.published.find_by_param(params[:project])
    empty_response_or_root_path(slice_research_path) unless @project
  end
end
