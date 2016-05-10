# frozen_string_literal: true

class Admin::ClinicalTrialsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner
  before_action :set_admin_clinical_trial, only: [:show, :edit, :update, :destroy]

  layout 'admin'

  def order
    @admin_clinical_trials = Admin::ClinicalTrial.current.order(:position)
  end

  # GET /admin/clinical_trials
  # GET /admin/clinical_trials.json
  def index
    @admin_clinical_trials = Admin::ClinicalTrial.current.order(:position)
  end

  # GET /admin/clinical_trials/1
  # GET /admin/clinical_trials/1.json
  def show
  end

  # GET /admin/clinical_trials/new
  def new
    @admin_clinical_trial = Admin::ClinicalTrial.new
  end

  # GET /admin/clinical_trials/1/edit
  def edit
  end

  # POST /admin/clinical_trials
  # POST /admin/clinical_trials.json
  def create
    @admin_clinical_trial = Admin::ClinicalTrial.new(admin_clinical_trial_params)

    respond_to do |format|
      if @admin_clinical_trial.save
        format.html { redirect_to @admin_clinical_trial, notice: 'Clinical trial was successfully created.' }
        format.json { render :show, status: :created, location: @admin_clinical_trial }
      else
        format.html { render :new }
        format.json { render json: @admin_clinical_trial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/clinical_trials/1
  # PATCH/PUT /admin/clinical_trials/1.json
  def update
    respond_to do |format|
      if @admin_clinical_trial.update(admin_clinical_trial_params)
        format.html { redirect_to params[:redirect_back] ? :back : @admin_clinical_trial, notice: 'Clinical trial was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_clinical_trial }
      else
        format.html { render :edit }
        format.json { render json: @admin_clinical_trial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/clinical_trials/1
  # DELETE /admin/clinical_trials/1.json
  def destroy
    @admin_clinical_trial.destroy
    respond_to do |format|
      format.html { redirect_to admin_clinical_trials_url, notice: 'Clinical trial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_clinical_trial
      @admin_clinical_trial = Admin::ClinicalTrial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_clinical_trial_params
      params.require(:admin_clinical_trial).permit(:title, :overview, :description, :eligibility, :phone, :email, :link, :displayed, :industry_sponsored, :position)
    end
end
