class Builder::SurveyEncountersController <  Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders

  before_action :set_editable_survey
  before_action :redirect_without_survey

  before_action :set_editable_survey_encounter,     only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_survey_encounter, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_path(@survey)
  end

  def new
    @survey_encounter = @survey.survey_encounters.new
  end

  def create
    @survey_encounter = @survey.survey_encounters.where(user_id: current_user.id).new(survey_encounter_params)

    respond_to do |format|
      if @survey_encounter.save
        format.html { redirect_to builder_survey_survey_encounter_path(@survey, @survey_encounter), notice: 'Survey Encounter was successfully created.' }
        format.json { render :show, status: :created, location: @survey_encounter }
      else
        format.html { render :new }
        format.json { render json: @survey_encounter.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @survey_encounter.update(survey_encounter_params)
        format.html { redirect_to builder_survey_survey_encounter_path(@survey, @survey_encounter), notice: 'Survey Encounter was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey_encounter }
      else
        format.html { render :edit }
        format.json { render json: @survey_encounter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @survey_encounter.destroy
    respond_to do |format|
      format.html { redirect_to builder_survey_path(@survey), notice: 'Survey Encounter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_editable_survey_encounter
      @survey_encounter = @survey.survey_encounters.find_by_id(params[:id])
    end

    def redirect_without_survey_encounter
      empty_response_or_root_path(builder_survey_path(@survey)) unless @survey_encounter
    end

    def survey_encounter_params
      params.require(:survey_encounter).permit(:encounter_id)
    end

end
