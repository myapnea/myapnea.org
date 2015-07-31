class BuilderController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_non_builders

  before_action :set_editable_survey,       only: [:show, :edit, :update, :destroy, :questions, :new_question, :create_question, :question, :edit_question, :update_question, :destroy_question]
  before_action :redirect_without_survey,   only: [:show, :edit, :update, :destroy, :questions, :new_question, :create_question, :question, :edit_question, :update_question, :destroy_question]

  before_action :set_editable_question,     only: [:question, :edit_question, :update_question, :destroy_question]
  before_action :redirect_without_question, only: [:question, :edit_question, :update_question, :destroy_question]

  def index
    @surveys = current_user.editable_surveys
  end

  def new
    @survey = current_user.editable_surveys.new
  end

  def create
    @survey = current_user.editable_surveys.new(survey_params)

    respond_to do |format|
      if @survey.save
        format.html { redirect_to builder_survey_path(id: @survey), notice: 'Survey was successfully created.' }
        format.json { render :show, status: :created, location: @survey }
      else
        format.html { render :new }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to builder_survey_path(id: @survey), notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to builder_surveys_path, notice: 'Survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def questions
    redirect_to builder_survey_path(id: @survey)
  end

  def new_question
    @question = @survey.questions.new
    render 'builder/questions/new'
  end

  def create_question
    @question = @survey.questions.where(user_id: current_user.id).new(question_params)

    respond_to do |format|
      if @question.save
        @survey.questions << @question
        format.html { redirect_to question_builder_survey_path(id: @survey, question_id: @question), notice: 'Survey was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render 'builder/questions/new' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def question
    render 'builder/questions/show'
  end

  def edit_question
    render 'builder/questions/edit'
  end

  def update_question
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to question_builder_survey_path(id: @survey, question_id: @question), notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render 'builder/questions/edit' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_question
    @question.destroy
    respond_to do |format|
      format.html { redirect_to builder_survey_path(id: @survey), notice: 'Survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def redirect_non_builders
      empty_response_or_root_path unless current_user.can_build_surveys?
    end

    def set_editable_survey
      @survey = current_user.editable_surveys.find_by_param(params[:id])
    end

    def redirect_without_survey
      empty_response_or_root_path(builder_surveys_path) unless @survey
    end

    def survey_params
      params.require(:survey).permit(:name_en, :slug, :status)
    end

    def set_editable_question
      @question = @survey.questions.find_by_param(params[:question_id])
    end

    def redirect_without_question
      empty_response_or_root_path(builder_survey_path(id: @survey)) unless @question
    end

    def question_params
      params.require(:question).permit(:text_en, :slug, :display_type)
    end

end
