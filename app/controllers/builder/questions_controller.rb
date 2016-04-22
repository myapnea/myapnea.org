# frozen_string_literal: true

# Allows survey editors to add and modify survey questions.
class Builder::QuestionsController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders
  before_action :find_editable_survey_or_redirect
  before_action :find_editable_question_or_redirect, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_path(@survey)
  end

  def new
    @question = @survey.questions.new
  end

  def create
    @question = @survey.questions.where(user_id: current_user.id).new(question_params)
    if @question.save
      @survey.survey_question_orders.create(question_id: @question.id, position: @survey.max_position + 1)
      redirect_to builder_survey_question_path(@survey, @question), notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to builder_survey_question_path(@survey, @question), notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to builder_survey_path(@survey), notice: 'Question was successfully destroyed.'
  end

  # POST /questions/reorder.js
  def reorder
    params[:question_ids].each_with_index do |question_id, index|
      sqo = @survey.survey_question_orders.find_by question_id: question_id
      sqo.update position: index if sqo
    end
    head :ok
  end

  private

  def find_editable_question_or_redirect
    super(:id)
  end

  def question_params
    params.require(:question).permit(:text_en, :slug, :archived)
  end
end
