class Builder::AnswerTemplatesController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders

  before_action :set_editable_survey
  before_action :redirect_without_survey

  before_action :set_editable_question
  before_action :redirect_without_question

  before_action :set_editable_answer_template,     only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_answer_template, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_question_path(@survey, @question)
  end

  def new
    @answer_template = @question.answer_templates.new
  end

  def create
    @answer_template = @question.answer_templates.where(user_id: current_user.id).new(answer_template_params)

    respond_to do |format|
      if @answer_template.save
        @question.answer_templates << @answer_template
        format.html { redirect_to builder_survey_question_answer_template_path(@survey, @question, @answer_template), notice: 'Answer Template was successfully created.' }
        format.json { render :show, status: :created, location: @answer_template }
      else
        format.html { render :new }
        format.json { render json: @answer_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @answer_template.update(answer_template_params)
        format.html { redirect_to builder_survey_question_answer_template_path(@survey, @question, @answer_template), notice: 'Answer Template was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer_template }
      else
        format.html { render :edit }
        format.json { render json: @answer_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @answer_template.destroy
    respond_to do |format|
      format.html { redirect_to builder_survey_question_path(@survey, @question), notice: 'Answer Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_editable_answer_template
      super(:id)
    end

    def answer_template_params
      params.require(:answer_template).permit(:name, :template_name, :parent_answer_template_id, :parent_answer_option_value, :text, :unit, :archived)
    end

end
