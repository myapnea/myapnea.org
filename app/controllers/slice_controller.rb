# frozen_string_literal: true

# Allows users to access Slice surveys.
class SliceController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_project_or_redirect, only: [
    :consent, :print_consent, :enrollment_consent, :enrollment_exit,
    :overview, :overview_report, :leave_study, :submit_leave_study
  ]
  before_action :find_subject_or_redirect, only: [
    :overview, :overview_report, :leave_study, :submit_leave_study
  ]

  # GET /surveys
  def surveys
    redirect_to slice_research_path unless current_user
    render layout: "layouts/full_page_sidebar"
  end

  # GET /research
  def research
    @projects = Project.published.order(:launch_date)
  end

  # GET /research/:project/consent
  def consent
    @subject = current_user&.subjects&.find_by(project: @project)
    render layout: "layouts/full_page_sidebar"
  end

  # GET /research/:project/consent.pdf
  def print_consent
    @subject = current_user&.subjects&.find_by(project: @project)
    pdf_file = Rails.root.join(@project.generate_printed_pdf!(@subject))
    if File.exist?(pdf_file)
      send_file(pdf_file, filename: "SleepINNOVATEConsentForm.pdf", type: "application/pdf", disposition: "inline")
    else
      redirect_to slice_consent_path(@project), alert: "Unable to generate PDF at this time."
    end
  end

  # GET /research/:project/overview
  def overview
    redirect_to slice_research_path unless current_user
    render layout: "layouts/full_page_sidebar"
  end

  # GET /research/:project/overview-report
  def overview_report
    redirect_to slice_research_path unless current_user
    render layout: "layouts/full_page_sidebar"
  end

  # GET /research/:project/leave-study
  def leave_study
    redirect_to slice_research_path unless current_user
    render layout: "layouts/full_page_sidebar"
  end

  # POST /research/:project/leave-study
  def submit_leave_study
    if params[:withdraw].to_s.casecmp("withdraw").zero?
      @subject.destroy
      redirect_to slice_research_path, notice: "You left the #{@project.name} study."
    else
      @withdraw_error = true
      render :leave_study, layout: "layouts/full_page_sidebar"
    end
  end

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

  def find_subject_or_redirect
    @subject = @project.subjects.find_by(user: current_user)
    empty_response_or_root_path(slice_research_path) unless @subject
  end
end
