# frozen_string_literal: true

# This controller handles recruiting users to external research studies.
class ParticipateController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project_or_redirect

  # GET /research/:project/participate
  def participate
    subject = current_user.subjects.where(project: @project).first_or_create(recruited_at: Time.zone.now)
    redirect_to @project.external_link
  end

  private

  def find_project_or_redirect
    @project = Project.published.find_by_param(params[:project])
    empty_response_or_root_path(slice_research_path) unless @project
  end
end
