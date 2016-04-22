# frozen_string_literal: true

# Allows survey builders to add answer options to answer templates
class Builder::AnswerOptionsController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders
  before_action :find_editable_survey_or_redirect
  before_action :find_editable_question_or_redirect
  before_action :find_editable_answer_template_or_redirect
  before_action :find_editable_answer_option_or_redirect, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_question_answer_template_path(@survey, @question, @answer_template)
  end

  def new
    @answer_option = @answer_template.answer_options.new
  end

  def create
    @answer_option = @answer_template.answer_options.where(user_id: current_user.id).new(answer_option_params)
    if @answer_option.save
      @answer_template.answer_options_answer_templates.create(answer_option_id: @answer_option.id, position: @answer_template.max_position + 1)
      redirect_to builder_survey_question_answer_template_answer_option_path(@survey, @question, @answer_template, @answer_option), notice: 'Answer Option was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @answer_option.update(answer_option_params)
      redirect_to builder_survey_question_answer_template_answer_option_path(@survey, @question, @answer_template, @answer_option), notice: 'Answer Option was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @answer_option.destroy
    redirect_to builder_survey_question_answer_template_path(@survey, @question, @answer_template), notice: 'Answer Option was successfully destroyed.'
  end

  # POST /answer_options/reorder.js
  def reorder
    params[:answer_option_ids].each_with_index do |answer_option_id, index|
      aoat = @answer_template.answer_options_answer_templates.find_by answer_option_id: answer_option_id
      aoat.update position: index if aoat
    end
    head :ok
  end

  private

  def find_editable_answer_option_or_redirect
    super(:id)
  end

  def answer_option_params
    params.require(:answer_option).permit(:text, :hotkey, :value, :display_class)
  end
end
