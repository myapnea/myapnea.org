# frozen_string_literal: true

# Allows survey builders to add encounters to surveys.
class Builder::SurveyEncountersController <  Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders
  before_action :find_editable_survey_or_redirect
  before_action :find_editable_survey_encounter_or_redirect, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_path(@survey)
  end

  def new
    @survey_encounter = @survey.survey_encounters.new
  end

  def create
    @survey_encounter = @survey.survey_encounters.where(user_id: current_user.id).new(survey_encounter_params)
    if @survey_encounter.save
      redirect_to builder_survey_survey_encounter_path(@survey, @survey_encounter), notice: 'Survey Encounter was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @survey_encounter.update(survey_encounter_params)
      redirect_to builder_survey_survey_encounter_path(@survey, @survey_encounter), notice: 'Survey Encounter was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @survey_encounter.destroy
    redirect_to builder_survey_path(@survey), notice: 'Survey Encounter was successfully destroyed.'
  end

  private

  def find_editable_survey_encounter_or_redirect
    @survey_encounter = @survey.survey_encounters.find_by(id: params[:id])
    redirect_without_survey_encounter
  end

  def redirect_without_survey_encounter
    empty_response_or_root_path(builder_survey_path(@survey)) unless @survey_encounter
  end

  def survey_encounter_params
    params.require(:survey_encounter).permit(:encounter_id, :parent_survey_encounter_id)
  end
end
