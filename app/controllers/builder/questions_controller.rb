class Builder::QuestionsController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders

  before_action :set_editable_survey
  before_action :redirect_without_survey

  before_action :set_editable_question,     only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_question, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_path(@survey)
  end

  def new
    @question = @survey.questions.new
  end

  def create
    @question = @survey.questions.where(user_id: current_user.id).new(question_params)

    respond_to do |format|
      if @question.save
        @survey.questions << @question
        format.html { redirect_to builder_survey_question_path(@survey, @question), notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to builder_survey_question_path(@survey, @question), notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to builder_survey_path(@survey), notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_editable_question
      super(:id)
    end

    def question_params
      params.require(:question).permit(:text_en, :slug, :display_type)
    end

end
