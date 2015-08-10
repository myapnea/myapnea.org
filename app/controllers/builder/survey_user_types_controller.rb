class Builder::SurveyUserTypesController < Builder::BuilderController
  before_action :authenticate_user!
  before_action :redirect_non_builders

  before_action :set_editable_survey
  before_action :redirect_without_survey

  before_action :set_editable_survey_user_type,     only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_survey_user_type, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to builder_survey_path(@survey)
  end

  def new
    @survey_user_type = @survey.survey_user_types.new
  end

  def create
    @survey_user_type = @survey.survey_user_types.where(user_id: current_user.id).new(survey_user_type_params)

    respond_to do |format|
      if @survey_user_type.save
        format.html { redirect_to builder_survey_survey_user_type_path(@survey, @survey_user_type), notice: 'Survey User Type was successfully created.' }
        format.json { render :show, status: :created, location: @survey_user_type }
      else
        format.html { render :new }
        format.json { render json: @survey_user_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @survey_user_type.update(survey_user_type_params)
        format.html { redirect_to builder_survey_survey_user_type_path(@survey, @survey_user_type), notice: 'Survey User Type was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey_user_type }
      else
        format.html { render :edit }
        format.json { render json: @survey_user_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @survey_user_type.destroy
    respond_to do |format|
      format.html { redirect_to builder_survey_path(@survey), notice: 'Survey User Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_editable_survey_user_type
      @survey_user_type = @survey.survey_user_types.find_by_id(params[:id])
    end

    def redirect_without_survey_user_type
      empty_response_or_root_path(builder_survey_path(@survey)) unless @survey_user_type
    end

    def survey_user_type_params
      params.require(:survey_user_type).permit(:user_type)
    end

end
