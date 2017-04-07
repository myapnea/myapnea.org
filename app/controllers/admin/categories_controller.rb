# frozen_string_literal: true

# Allows admins to create and modify broadcast categories.
class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_admin_category_or_redirect, only: [:show, :edit, :update, :destroy]

  # GET /admin/categories
  def index
    @admin_categories = Admin::Category.current.order(:name).page(params[:page]).per(40)
  end

  # # GET /admin/categories/1
  # def show
  # end

  # GET /admin/categories/new
  def new
    @admin_category = Admin::Category.new
  end

  # # GET /admin/categories/1/edit
  # def edit
  # end

  # POST /admin/categories
  def create
    @admin_category = Admin::Category.new(admin_category_params)

    if @admin_category.save
      redirect_to @admin_category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  # PATCH /admin/categories/1
  def update
    if @admin_category.update(admin_category_params)
      redirect_to @admin_category, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/categories/1
  def destroy
    @admin_category.destroy
    redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
  end

  private

  def find_admin_category_or_redirect
    @admin_category = Admin::Category.current.find_by_param params[:id]
    redirect_without_admin_category
  end

  def redirect_without_admin_category
    empty_response_or_root_path(admin_categories_path) unless @admin_category
  end

  def admin_category_params
    params.require(:admin_category).permit(:name, :slug)
  end
end
