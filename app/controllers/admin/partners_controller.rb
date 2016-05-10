# frozen_string_literal: true

class Admin::PartnersController < ApplicationController
  before_action :authenticate_user!,  except: [:photo]
  before_action :check_owner,         except: [:photo]
  before_action :set_admin_partner,   only: [:show, :edit, :update, :destroy, :photo]

  layout 'admin'

  def photo
    if @admin_partner.photo.size > 0
      send_file File.join(CarrierWave::Uploader::Base.root, @admin_partner.photo.url)
    else
      head :ok
    end
  end

  # GET /admin/partners
  # GET /admin/partners.json
  def index
    @admin_partners = Admin::Partner.current.order('position')
  end

  # GET /admin/partners/1
  # GET /admin/partners/1.json
  def show
    redirect_to admin_partners_path
  end

  # GET /admin/partners/new
  def new
    @admin_partner = Admin::Partner.new
  end

  # GET /admin/partners/1/edit
  def edit
  end

  # POST /admin/partners
  # POST /admin/partners.json
  def create
    @admin_partner = Admin::Partner.new(admin_partner_params)

    respond_to do |format|
      if @admin_partner.save
        format.html { redirect_to @admin_partner, notice: 'Partner was successfully created.' }
        format.json { render :show, status: :created, location: @admin_partner }
      else
        format.html { render :new }
        format.json { render json: @admin_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/partners/1
  # PATCH/PUT /admin/partners/1.json
  def update
    respond_to do |format|
      if @admin_partner.update(admin_partner_params)
        format.html { redirect_to @admin_partner, notice: 'Partner was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_partner }
      else
        format.html { render :edit }
        format.json { render json: @admin_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/partners/1
  # DELETE /admin/partners/1.json
  def destroy
    @admin_partner.destroy
    respond_to do |format|
      format.html { redirect_to admin_partners_url, notice: 'Partner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_partner
      @admin_partner = Admin::Partner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_partner_params
      params.require(:admin_partner).permit(:name, :description, :photo, :link, :position, :displayed, :group)
    end
end
