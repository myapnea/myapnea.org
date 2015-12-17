class Builder::SurveysController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders

  before_action :set_editable_survey,       only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_survey,   only: [:show, :edit, :update, :destroy]

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


  private

    def set_editable_survey
      super(:id)
    end

    def survey_params
      params.require(:survey).permit(:name_en, :description_en, :slug, :status, :pediatric, :pediatric_diagnosed, :child_min_age, :child_max_age)
    end

end
