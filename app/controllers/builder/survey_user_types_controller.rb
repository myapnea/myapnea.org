# frozen_string_literal: true

# Allows survey builders to specify user types for survey.
class Builder::SurveyUserTypesController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders
  before_action :find_editable_survey_or_redirect
  before_action :find_editable_survey_user_type_or_redirect, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_path(@survey)
  end

  def new
    @survey_user_type = @survey.survey_user_types.new
  end

  def create
    @survey_user_type = @survey.survey_user_types.where(user_id: current_user.id).new(survey_user_type_params)
    if @survey_user_type.save
      redirect_to builder_survey_survey_user_type_path(@survey, @survey_user_type), notice: 'Survey User Type was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @survey_user_type.update(survey_user_type_params)
      redirect_to builder_survey_survey_user_type_path(@survey, @survey_user_type), notice: 'Survey User Type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @survey_user_type.destroy
    redirect_to builder_survey_path(@survey), notice: 'Survey User Type was successfully destroyed.'
  end

  private

  def find_editable_survey_user_type_or_redirect
    @survey_user_type = @survey.survey_user_types.find_by_id(params[:id])
    redirect_without_survey_user_type
  end

  def redirect_without_survey_user_type
    empty_response_or_root_path(builder_survey_path(@survey)) unless @survey_user_type
  end

  def survey_user_type_params
    params.require(:survey_user_type).permit(:user_type)
  end
end
