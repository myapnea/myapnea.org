# frozen_string_literal: true

# Allows users to invite others to build and edit a survey together.
class Builder::SurveyEditorsController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders
  before_action :find_editable_survey_or_redirect
  before_action :find_survey_editor_or_redirect, only: [:show, :edit, :update, :destroy]

  # # GET /builder/survey_editors
  # def index
  #   @survey_editors = @survey.survey_editors
  # end

  # # GET /builder/survey_editors/1
  # def show
  # end

  # GET /builder/survey_editors/new
  def new
    @survey_editor = SurveyEditor.new
  end

  # GET /builder/survey_editors/1/edit
  def edit
  end

  # POST /builder/survey_editors
  def create
    @survey_editor = @survey.survey_editors.where(creator_id: current_user.id).new(survey_editor_params)
    if @survey_editor.save
      redirect_to builder_survey_path(@survey), notice: 'Survey editor was successfully created.'
    else
      render :new
    end
  end

  # PATCH /builder/survey_editors/1
  def update
    if @survey_editor.update(survey_editor_params)
      redirect_to builder_survey_path(@survey), notice: 'Survey editor was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /builder/survey_editors/1
  def destroy
    @survey_editor.destroy
    redirect_to builder_survey_path(@survey), notice: 'Survey editor was successfully deleted.'
  end

  private

  def find_survey_editor_or_redirect
    @survey_editor = @survey.survey_editors.find_by id: params[:id]
    redirect_without_survey_editor
  end

  def redirect_without_survey_editor
    empty_response_or_root_path(builder_survey_path(@survey)) unless @survey_editor
  end

  def survey_editor_params
    params[:survey_editor] ||= { blank: '1' }
    params.require(:survey_editor).permit(:user_id, :invite_token, :invite_email)
  end
end
