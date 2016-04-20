# frozen_string_literal: true

# Allows flagged users to build surveys online.
class Builder::SurveysController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders
  before_action :find_editable_survey_or_redirect, only: [:show, :preview, :edit, :update, :destroy]

  def index
    @surveys = current_user.editable_surveys
  end

  def new
    @survey = Survey.where(user_id: current_user.id).new
  end

  def create
    @survey = Survey.where(user_id: current_user.id).new(survey_params)
    if @survey.save
      redirect_to builder_survey_path(id: @survey), notice: 'Survey was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  # GET /builder/surveys/:id/preview
  def preview
    @answer_session = current_user.answer_sessions.where(survey_id: @survey).new
  end

  def edit
  end

  def update
    if @survey.update(survey_params)
      redirect_to builder_survey_path(id: @survey), notice: 'Survey was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
    redirect_to builder_surveys_path, notice: 'Survey was successfully deleted.'
  end

  private

  def find_editable_survey_or_redirect
    super(:id)
  end

  def survey_params
    params.require(:survey).permit(
      :name_en, :description_en, :slug, :status, :pediatric,
      :pediatric_diagnosed, :child_min_age, :child_max_age
    )
  end
end
