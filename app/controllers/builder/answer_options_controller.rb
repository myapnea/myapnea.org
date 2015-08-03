class Builder::AnswerOptionsController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders

  before_action :set_editable_survey
  before_action :redirect_without_survey

  before_action :set_editable_question
  before_action :redirect_without_question

  before_action :set_editable_answer_template
  before_action :redirect_without_answer_template

  before_action :set_editable_answer_option,        only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_answer_option,    only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_question_answer_template_path(@survey, @question, @answer_template)
  end

  def new
    @answer_option = @answer_template.answer_options.new
  end

  def create
    @answer_option = @answer_template.answer_options.where(user_id: current_user.id).new(answer_option_params)

    respond_to do |format|
      if @answer_option.save
        @answer_template.answer_options << @answer_option
        format.html { redirect_to builder_survey_question_answer_template_answer_option_path(@survey, @question, @answer_template, @answer_option), notice: 'Answer Option was successfully created.' }
        format.json { render :show, status: :created, location: @answer_option }
      else
        format.html { render :new }
        format.json { render json: @answer_option.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @answer_option.update(answer_option_params)
        format.html { redirect_to builder_survey_question_answer_template_answer_option_path(@survey, @question, @answer_template, @answer_option), notice: 'Answer Option was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer_option }
      else
        format.html { render :edit }
        format.json { render json: @answer_option.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @answer_option.destroy
    respond_to do |format|
      format.html { redirect_to builder_survey_question_answer_template_path(@survey, @question, @answer_template), notice: 'Answer Option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_editable_answer_option
      super(:id)
    end

    def answer_option_params
      params.require(:answer_option).permit(:text, :hotkey, :value)
    end

end
