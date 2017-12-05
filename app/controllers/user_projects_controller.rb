# frozen_string_literal: true

# Allows users to consent and get added to active studies.
class UserProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_project, only: [
    :show, :edit, :update, :destroy,
    :start, :page, :resume, :submit_page, :complete
  ]
  before_action :find_page, only: [:page, :submit_page]

  layout "layouts/full_page"

  # GET /user_projects
  def index
    @user_projects = current_user.user_projects
  end

  # # GET /user_projects/1
  # def show
  # end

  # GET /user_projects/new
  def new
    @user_project = current_user.user_projects.new
  end

  # # GET /user_projects/1/edit
  # def edit
  # end

  # POST /user_projects
  def create
    @user_project = current_user.user_projects.new(user_project_params)
    if @user_project.save
      @user_project.update(consented_at: Time.zone.now)
      @user_project.find_or_create_subject!
      redirect_to slice_surveys_path, notice: "User project was successfully created."
    else
      render :new
    end
  end

  # PATCH /user_projects/1
  def update
    if @user_project.update(user_project_params)
      redirect_to slice_surveys_path, notice: "User project was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /user_projects/1
  def destroy
    @user_project.destroy
    redirect_to slice_surveys_path, notice: "User project was successfully deleted."
  end



  # GET /user_projects/1  ....  /survey/:event/:design/start
  def start
    survey_in_progress
    redirect_to page_user_project_path(@user_project, params[:event], params[:design], 1)
  end

  # GET /user_projects/1  ....  /survey/:event/:design/:page
  def page
    @json = @user_project.page_event_survey(params[:event], params[:design], @page)
    @survey = Slice::Survey.new(json: @json)
    if @json.present?
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
    end
    if @json.blank?
      redirect_to complete_user_project_path(@user_project, params[:event], params[:design])
    else
      render "survey/page"
    end
  end

  # GET /user_projects/1  ....  /survey/:event/:design/:resume
  def resume
    survey_in_progress
    @json = @user_project.resume_event_survey(params[:event], params[:design])
    @survey = Slice::Survey.new(json: @json)
    if @json.blank?
      redirect_to complete_user_project_path(@user_project, params[:event], params[:design])
    else
      @page = @json.dig("design", "current_page")
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
      render "survey/page"
    end
  end

  # PATCH /survey/:event/:design/:page
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
    (@json, @status) = @user_project.submit_response_event_survey(params[:event], params[:design], @page, value, request.remote_ip)
    if @status.is_a?(Net::HTTPOK)
      redirect_to page_user_project_path(@user_project, params[:event], params[:design], @page + 1)
    elsif @json
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
      render :page
    else
      redirect_to page_user_project_path(@user_project, params[:event], params[:design], @page)
    end
  end

  # GET /survey/:event/:design/complete
  def complete
    survey_completed
    redirect_to slice_surveys_path
  end

  private

  def set_user_project
    @user_project = current_user.user_projects.find_by(id: params[:id])
  end

  def user_project_params
    params.fetch(:user_project, {}).permit(:project_id)
  end






  def find_user_survey
    # TODO: Implement
    # current_user.user_surveys.where(event: params[:event].downcase, design: params[:design].downcase).first_or_create
  end

  def survey_in_progress
    # TODO: Implement
    # find_user_survey.update(completed: false)
  end

  def survey_completed
    # TODO: Implement
    # find_user_survey.update(completed: true)
  end

  def find_page
    @page = [params[:page].to_i, 1].max
  end
end
