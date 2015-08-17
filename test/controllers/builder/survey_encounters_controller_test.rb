require 'test_helper'

class Builder::SurveyEncountersControllerTest < ActionController::TestCase
  setup do
    @builder = users(:builder)
    @regular_user = users(:user_1)
    @survey = surveys(:built_on_web)
    @survey_encounter = survey_encounters(:web_encounter_baseline)
  end

  test "should get survey encounters as builder" do
    login(@builder)
    get :index, survey_id: @survey
    assert_not_nil assigns(:survey)
    assert_redirected_to builder_survey_path(assigns(:survey))
  end

  test "should not get survey encounters as regular user" do
    login(@regular_user)
    get :index, survey_id: @survey
    assert_nil assigns(:survey)
    assert_redirected_to root_path
  end

  test "should get new survey encounter as builder" do
    login(@builder)
    get :new, survey_id: @survey
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert_response :success
  end

  test "should not get new survey encounter as regular user" do
    login(@regular_user)
    get :new, survey_id: @survey
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_encounter)
    assert_redirected_to root_path
  end

  test "should create survey encounter as builder" do
    login(@builder)
    assert_difference('SurveyEncounter.count') do
      post :create, survey_id: @survey, survey_encounter: { encounter_id: encounters(:"12month").id }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert_equal encounters(:"12month"), assigns(:survey_encounter).encounter
    assert_redirected_to builder_survey_survey_encounter_path(assigns(:survey), assigns(:survey_encounter))
  end

  test "should not create survey encounter without encounter" do
    login(@builder)
    assert_difference('SurveyEncounter.count', 0) do
      post :create, survey_id: @survey, survey_encounter: { encounter_id: nil }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert assigns(:survey_encounter).errors.size > 0
    assert_equal ["can't be blank"], assigns(:survey_encounter).errors[:encounter_id]
    assert_template 'survey_encounters/new'
    assert_response :success
  end

  test "should not create survey encounter as regular user" do
    login(@regular_user)
    assert_difference('SurveyEncounter.count', 0) do
      post :create, survey_id: @survey, survey_encounter: { encounter_id: encounters(:"12month").id }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_encounter)
    assert_redirected_to root_path
  end

  test "should show survey encounter as builder" do
    login(@builder)
    get :show, survey_id: @survey, id: @survey_encounter
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert_response :success
  end

  test "should not show survey encounter as regular user" do
    login(@regular_user)
    get :show, survey_id: @survey, id: @survey_encounter
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_encounter)
    assert_redirected_to root_path
  end

  test "should get edit survey encounter as builder" do
    login(@builder)
    get :edit, survey_id: @survey, id: @survey_encounter
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert_response :success
  end

  test "should not get edit survey encounter as regular user" do
    login(@regular_user)
    get :edit, survey_id: @survey, id: @survey_encounter
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_encounter)
    assert_redirected_to root_path
  end

  test "should update survey encounter as builder" do
    login(@builder)
    patch :update, survey_id: @survey, id: @survey_encounter, survey_encounter: { encounter_id: encounters(:"12month").id }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert_equal encounters(:"12month"), assigns(:survey_encounter).encounter
    assert_redirected_to builder_survey_survey_encounter_path(assigns(:survey), assigns(:survey_encounter))
  end

  test "should not update survey encounter without encounter" do
    login(@builder)
    patch :update, survey_id: @survey, id: @survey_encounter, survey_encounter: { encounter_id: nil }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert assigns(:survey_encounter).errors.size > 0
    assert_equal ["can't be blank"], assigns(:survey_encounter).errors[:encounter_id]
    assert_template 'survey_encounters/edit'
    assert_response :success
  end

  test "should not update survey encounter as regular user" do
    login(@regular_user)
    patch :update, survey_id: @survey, id: @survey_encounter, survey_encounter: { encounter_id: encounters(:"12month").id }
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_encounter)
    assert_redirected_to root_path
  end

  test "should destroy survey encounter as builder" do
    login(@builder)
    assert_difference('SurveyEncounter.count', -1) do
      delete :destroy, survey_id: @survey, id: @survey_encounter
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_encounter)
    assert_redirected_to builder_survey_path(assigns(:survey))
  end

  test "should not destroy survey encounter as regular user" do
    login(@regular_user)
    assert_difference('SurveyEncounter.count', 0) do
      delete :destroy, survey_id: @survey, id: @survey_encounter
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_encounter)
    assert_redirected_to root_path
  end
end
