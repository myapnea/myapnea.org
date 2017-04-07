# frozen_string_literal: true

require 'test_helper'

class Builder::SurveyUserTypesControllerTest < ActionController::TestCase
  setup do
    @builder = users(:builder)
    @regular_user = users(:user_1)
    @survey = surveys(:built_on_web)
    @survey_user_type = survey_user_types(:web_survey_user_type_adult_diagnosed)
  end

  test 'should get survey_user_types as builder' do
    login(@builder)
    get :index, params: { survey_id: @survey }
    assert_not_nil assigns(:survey)
    assert_redirected_to builder_survey_path(assigns(:survey))
  end

  test 'should not get survey_user_types as regular user' do
    login(@regular_user)
    get :index, params: { survey_id: @survey }
    assert_nil assigns(:survey)
    assert_redirected_to root_path
  end

  test 'should get new survey_user_type as builder' do
    login(@builder)
    get :new, params: { survey_id: @survey }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_response :success
  end

  test 'should not get new survey_user_type as regular user' do
    login(@regular_user)
    get :new, params: { survey_id: @survey }
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_user_type)
    assert_redirected_to root_path
  end

  test 'should create survey_user_type as builder' do
    login(@builder)
    assert_difference('SurveyUserType.count') do
      post :create, params: { survey_id: @survey, survey_user_type: { user_type: 'caregiver_adult' } }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_equal 'caregiver_adult', assigns(:survey_user_type).user_type
    assert_redirected_to builder_survey_survey_user_type_path(assigns(:survey), assigns(:survey_user_type))
  end

  test 'should not create survey_user_type without user type' do
    login(@builder)
    assert_difference('SurveyUserType.count', 0) do
      post :create, params: { survey_id: @survey, survey_user_type: { user_type: '' } }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_equal ["can't be blank", 'is not included in the list'], assigns(:survey_user_type).errors[:user_type]
    assert_template 'survey_user_types/new'
    assert_response :success
  end

  test 'should not create survey_user_type as regular user' do
    login(@regular_user)
    assert_difference('SurveyUserType.count', 0) do
      post :create, params: { survey_id: @survey, survey_user_type: { user_type: 'caregiver_adult' } }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_user_type)
    assert_redirected_to root_path
  end

  test 'should show survey_user_type as builder' do
    login(@builder)
    get :show, params: { survey_id: @survey, id: @survey_user_type }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_response :success
  end

  test 'should not show survey_user_type as regular user' do
    login(@regular_user)
    get :show, params: { survey_id: @survey, id: @survey_user_type }
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_user_type)
    assert_redirected_to root_path
  end

  test 'should get edit survey_user_type as builder' do
    login(@builder)
    get :edit, params: { survey_id: @survey, id: @survey_user_type }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_response :success
  end

  test 'should not get edit survey_user_type as regular user' do
    login(@regular_user)
    get :edit, params: { survey_id: @survey, id: @survey_user_type }
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_user_type)
    assert_redirected_to root_path
  end

  test 'should update survey_user_type as builder' do
    login(@builder)
    patch :update, params: { survey_id: @survey, id: @survey_user_type, survey_user_type: { user_type: 'caregiver_adult' } }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_equal 'caregiver_adult', assigns(:survey_user_type).user_type
    assert_redirected_to builder_survey_survey_user_type_path(assigns(:survey), assigns(:survey_user_type))
  end

  test 'should not update survey_user_type without user type' do
    login(@builder)
    patch :update, params: { survey_id: @survey, id: @survey_user_type, survey_user_type: { user_type: '' } }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_equal ["can't be blank", 'is not included in the list'], assigns(:survey_user_type).errors[:user_type]
    assert_template 'survey_user_types/edit'
    assert_response :success
  end

  test 'should not update survey_user_type as regular user' do
    login(@regular_user)
    patch :update, params: { survey_id: @survey, id: @survey_user_type, survey_user_type: { user_type: 'caregiver_adult' } }
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_user_type)
    assert_redirected_to root_path
  end

  test 'should destroy survey_user_type as builder' do
    login(@builder)
    assert_difference('SurveyUserType.current.count', -1) do
      delete :destroy, params: { survey_id: @survey, id: @survey_user_type }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:survey_user_type)
    assert_redirected_to builder_survey_path(assigns(:survey))
  end

  test 'should not destroy survey_user_type as regular user' do
    login(@regular_user)
    assert_difference('SurveyUserType.current.count', 0) do
      delete :destroy, params: { survey_id: @survey, id: @survey_user_type }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:survey_user_type)
    assert_redirected_to root_path
  end
end
