# frozen_string_literal: true

# Allows subjects to start and fill out project surveys.
class Slice::SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project_or_redirect
  before_action :find_subject_or_redirect
  before_action :find_page, only: [:page, :submit_page]

  layout "layouts/full_page"

  # GET /surveys/:project
  def surveys
    render layout: "layouts/full_page_sidebar"
  end

  # GET /surveys/:project/:event/:design/start
  def start
    survey_in_progress
    redirect_to slice_surveys_page_path(@project, params[:event], params[:design], 1)
  end

  # GET /surveys/:project/:event/:design/:page
  def page
    @json = @subject.page_event_survey(params[:event], params[:design], @page)
    @survey = Slice::Survey.new(json: @json)
    if @json.present?
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
    end
    if @json.blank?
      redirect_to slice_surveys_review_path(@project, params[:event], params[:design])
    else
      render "slice/surveys/page"
    end
  end

  # GET /surveys/:project/:event/:design/resume
  def resume
    survey_in_progress
    @json = @subject.resume_event_survey(params[:event], params[:design])
    @survey = Slice::Survey.new(json: @json)
    if @json.blank?
      redirect_to slice_surveys_review_path(@project, params[:event], params[:design])
    else
      @page = @json.dig("design", "current_page")
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
      render "slice/surveys/page"
    end
  end

  # PATCH /slice/surveys/:project/:event/:design/:page
  def submit_page
    if params[:response].is_a?(ActionController::Parameters)
      value = {
        day: params[:response][:day],
        month: params[:response][:month],
        year: params[:response][:year],
        hours: params[:response][:hours],
        minutes: params[:response][:minutes],
        seconds: params[:response][:seconds],
        period: params[:response][:period],
        pounds: params[:response][:pounds],
        ounces: params[:response][:ounces],
        feet: params[:response][:feet],
        inches: params[:response][:inches]
      }
    else
      value = params[:response]
    end
    (@json, @status) = @subject.submit_response_event_survey(params[:event], params[:design], @page, value, request.remote_ip)
    if @status.is_a?(Net::HTTPOK)
      if params[:review] == "1"
        redirect_to slice_surveys_review_path(@project, params[:event], params[:design])
      else
        redirect_to slice_surveys_page_path(@project, params[:event], params[:design], @page + 1)
      end
    elsif @json
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
      render "slice/surveys/page"
    else
      redirect_to slice_surveys_page_path(@project, params[:event], params[:design], @page)
    end
  end

  # GET /surveys/:project/:event/:design/review
  def review
    (@json, @status) = @subject.review_event_survey(params[:event].downcase, params[:design].downcase)
  end

  # POST /surveys/:project/:event/:design/review
  def complete
    survey_completed
    if @subject.next_survey
      redirect_to slice_surveys_start_path(@project, @subject.next_survey.event_id, @subject.next_survey.design_id)
    else
      redirect_to slice_overview_path(@project)
    end
  end

  # GET /surveys/:project/:event/:design/report
  def report
    (@json, @status) = @subject.report_event_survey(params[:event], params[:design])
    render layout: "layouts/full_page_sidebar"
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

  def subject_params
    params.fetch(:subject, {}).permit(:project_id)
  end

  def find_subject_survey
    @subject.subject_surveys.where(event: params[:event].downcase, design: params[:design].downcase).first_or_create
  end

  def survey_in_progress
    find_subject_survey.update(completed_at: nil)
  end

  def survey_completed
    find_subject_survey.update(completed_at: Time.zone.now)
  end

  def find_page
    @page = [params[:page].to_i, 1].max
  end
end
