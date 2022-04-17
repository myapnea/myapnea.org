# frozen_string_literal: true

# Allows admins to modify resources page.
class Admin::ResourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_admin_resource_or_redirect, only: [
    :show, :edit, :update, :destroy
  ]

  layout "layouts/full_page_sidebar"

  # GET /admin/resources
  def index
    @admin_resources = Admin::Resource.current.order(:position).page(params[:page]).per(10)
  end

  # # GET /admin/resources/1
  # def show
  # end

  # GET /admin/resources/new
  def new
    @admin_resource = Admin::Resource.new
  end

  # # GET /admin/resources/1/edit
  # def edit
  # end

  # POST /admin/resources
  def create
    @admin_resource = Admin::Resource.new(admin_resource_params)
    if @admin_resource.save
      redirect_to @admin_resource, notice: "Resource was successfully created."
    else
      render :new
    end
  end

  # PATCH /admin/resources/1
  def update
    if @admin_resource.update(admin_resource_params)
      redirect_to @admin_resource, notice: "Resource was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /admin/resources/1
  def destroy
    @admin_resource.destroy
    redirect_to admin_resources_path, notice: "Resource was successfully deleted."
  end

  private

  def find_admin_resource_or_redirect
    @admin_resource = Admin::Resource.find_by_param(params[:id])
    redirect_without_admin_resource
  end

  def redirect_without_admin_resource
    empty_response_or_root_path(admin_resources_path) unless @admin_resource
  end

  def admin_resource_params
    params.require(:admin_resource).permit(
      :name, :slug, :description, :photo, :link, :position, :displayed
    )
  end
end
