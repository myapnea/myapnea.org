# frozen_string_literal: true

# Allows admins to create exports.
class Admin::ExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_admin_export_or_redirect, only: [:show, :progress, :file, :destroy]

  layout 'application_padded'

  # GET /admin/exports
  def index
    @admin_exports = current_user.exports.page(params[:page]).per(10)
  end

  # # GET /admin/exports/1
  # def show
  # end

  # # GET /admin/exports/1.js
  # def progress
  # end

  def file
    if @admin_export.file.size > 0
      send_file File.join(CarrierWave::Uploader::Base.root, @admin_export.file.url)
    else
      head :ok
    end
  end

  # # GET /admin/exports/new
  # def new
  #   @admin_export = current_user.exports.new
  # end

  # # GET /admin/exports/1/edit
  # def edit
  # end

  # POST /admin/exports
  def create
    @admin_export = current_user.exports.new
    if @admin_export.save
      @admin_export.start_export_in_background!
      redirect_to @admin_export, notice: 'Export was successfully created.'
    else
      render :new
    end
  end

  # # PATCH /admin/exports/1
  # def update
  #   if @admin_export.update(admin_export_params)
  #     redirect_to @admin_export, notice: 'Export was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /admin/exports/1
  def destroy
    @admin_export.destroy
    respond_to do |format|
      format.html { redirect_to admin_exports_path, notice: 'Export was successfully destroyed.' }
      format.js
    end
  end

  private

  def find_admin_export_or_redirect
    @admin_export = Admin::Export.find_by(id: params[:id])
    redirect_without_admin_export
  end

  def redirect_without_admin_export
    empty_response_or_root_path(admin_exports_path) unless @admin_export
  end
end
