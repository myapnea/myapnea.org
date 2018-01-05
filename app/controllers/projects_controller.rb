# frozen_string_literal: true

# Allows admins to manage projects.
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_project_or_redirect, only: [
    :show, :edit, :update, :destroy, :consent
  ]

  layout "layouts/full_page_sidebar"

  # GET /projects
  def index
    @projects = Project.current.order(:launch_date).page(params[:page]).per(40)
  end

  # # GET /projects/1/consent
  # def consent
  # end

  # # GET /projects/1
  # def show
  # end

  # GET /projects/new
  def new
    @project = current_user.projects.new
  end

  # # GET /projects/1/edit
  # def edit
  # end

  # POST /projects
  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new
    end
  end

  # PATCH /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully deleted."
  end

  private

  def find_project_or_redirect
    @project = Project.current.find_by_param(params[:id])
    redirect_without_project
  end

  def redirect_without_project
    empty_response_or_root_path(projects_path) unless @project
  end

  def project_params
    params[:project] ||= { blank: "1" }
    parse_date_if_key_present(:project, :launch_date)
    params.fetch(:project, {}).permit(
      :name, :slug, :access_token, :short_description, :consent, :theme,
      :launch_date, :published, :slice_site_id, :slice_baseline_event,
      :code_prefix
    )
  end
end
