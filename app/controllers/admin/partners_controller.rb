# frozen_string_literal: true

# Allows admins to modify partners page.
class Admin::PartnersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_admin_partner_or_redirect, only: [
    :show, :edit, :update, :destroy
  ]

  layout "layouts/full_page_sidebar"

  # GET /admin/partners
  def index
    @admin_partners = Admin::Partner.current.order(:group, :position).page(params[:page]).per(10)
  end

  # GET /admin/partners/1
  def show
    redirect_to admin_partners_path
  end

  # GET /admin/partners/new
  def new
    @admin_partner = Admin::Partner.new
  end

  # # GET /admin/partners/1/edit
  # def edit
  # end

  # POST /admin/partners
  def create
    @admin_partner = Admin::Partner.new(admin_partner_params)
    if @admin_partner.save
      redirect_to @admin_partner, notice: "Partner was successfully created."
    else
      render :new
    end
  end

  # PATCH /admin/partners/1
  def update
    if @admin_partner.update(admin_partner_params)
      redirect_to @admin_partner, notice: "Partner was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /admin/partners/1
  def destroy
    @admin_partner.destroy
    redirect_to admin_partners_path, notice: "Partner was successfully deleted."
  end

  private

  def find_admin_partner_or_redirect
    @admin_partner = Admin::Partner.find_by(id: params[:id])
    redirect_without_admin_partner
  end

  def redirect_without_admin_partner
    empty_response_or_root_path(admin_partners_path) unless @admin_partner
  end

  def admin_partner_params
    params.require(:admin_partner).permit(
      :name, :description, :photo, :link, :position, :displayed, :group
    )
  end
end
