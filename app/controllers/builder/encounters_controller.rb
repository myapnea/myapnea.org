# frozen_string_literal: true

class Builder::EncountersController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :check_owner

  before_action :set_editable_encounter,     only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_encounter, only: [:show, :edit, :update, :destroy]

  def index
    @encounters = Encounter.current
  end

  def new
    @encounter = Encounter.new
  end

  def create
    @encounter = current_user.encounters.new(encounter_params)

    respond_to do |format|
      if @encounter.save
        format.html { redirect_to builder_encounter_path(@encounter), notice: 'Encounter was successfully created.' }
        format.json { render :show, status: :created, location: @encounter }
      else
        format.html { render :new }
        format.json { render json: @encounter.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @encounter.update(encounter_params)
        format.html { redirect_to builder_encounter_path(@encounter), notice: 'Encounter was successfully updated.' }
        format.json { render :show, status: :ok, location: @encounter }
      else
        format.html { render :edit }
        format.json { render json: @encounter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @encounter.destroy
    respond_to do |format|
      format.html { redirect_to builder_encounters_path, notice: 'Encounter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_editable_encounter
      @encounter = Encounter.current.find_by_param(params[:id])
    end

    def redirect_without_encounter
      empty_response_or_root_path(builder_encounters_path) unless @encounter
    end

    def encounter_params
      params.require(:encounter).permit(:name, :slug, :launch_days_after_sign_up)
    end

end
