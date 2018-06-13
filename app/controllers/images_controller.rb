# frozen_string_literal: true

# Allows user to insert images into blog and forum posts.
class ImagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :index, :new, :edit, :create, :create_multiple, :update, :destroy
  ]
  before_action :check_admin, only: [
    :index, :edit, :update, :destroy
  ]
  before_action :find_image_or_redirect, only: [
    :show, :download, :edit, :update, :destroy
  ]

  # GET /images
  def index
    @images = Image.order(id: :desc).page(params[:page]).per(40)
    render layout: "layouts/full_page_sidebar"
  end

  # # GET /images/1
  # def show
  # end

  def download
    case params[:size]
    when "preview"
      send_file_if_present @image.image.preview
    when "thumb"
      send_file_if_present @image.image.thumb
    else
      send_file_if_present @image.image
    end
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
    render layout: "layouts/full_page_sidebar"
  end

  # POST /images
  def create
    @image = current_user.images.new(image_params)
    if @image.save
      @image.update file_size: @image.image.size
      redirect_to @image, notice: "Image was successfully created."
    else
      render :new
    end
  end

  # POST /:category_id/documents/upload.js
  def create_multiple
    @ids = []
    params[:images].each do |image|
      image = current_user.images.create(image: image, file_size: image.size)
      @ids << image.to_param
    end
  end

  # PATCH /images/1
  def update
    if @image.update(image_params)
      redirect_to @image, notice: "Image was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /images/1
  def destroy
    @image.destroy
    redirect_to images_path, notice: "Image was successfully deleted."
  end

  private

  def find_image_or_redirect
    @image = Image.find_by(id: Image.decode_id(params[:id]))
    empty_response_or_root_path(images_path) unless @image
  end

  def image_params
    params.require(:image).permit(:image, :image_cache)
  end
end
