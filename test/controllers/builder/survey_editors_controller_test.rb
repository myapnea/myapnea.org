# frozen_string_literal: true

require 'test_helper'

# Test to make sure that users can invite fellow users to build and edit surveys
class Builder::SurveyEditorsControllerTest < ActionController::TestCase
  setup do
    @survey_editor = survey_editors(:one)
    @builder = users(:builder)
    @survey = surveys(:built_on_web)
  end

  def survey_editor_params
    {
      creator_id: @survey_editor.creator_id,
      invite_email: @survey_editor.invite_email,
      invite_token: 'new-token',
      survey_id: @survey_editor.survey_id,
      user_id: @survey_editor.user_id
    }
  end

  # test 'should get index' do
  #   login(@builder)
  #   get :index, params: { survey_id: @survey }
  #   assert_response :success
  #   assert_not_nil assigns(:survey_editors)
  # end

  test 'should get new' do
    login(@builder)
    get :new, params: { survey_id: @survey }
    assert_response :success
  end

  test 'should create survey editor' do
    login(@builder)
    assert_difference('SurveyEditor.count') do
      post :create, params: { survey_id: @survey, survey_editor: survey_editor_params }
    end
    assert_redirected_to builder_survey_path(@survey)
  end

  test 'should not create survey editor without selected editor' do
    login(@builder)
    assert_difference('SurveyEditor.count', 0) do
      post :create, params: { survey_id: @survey, survey_editor: survey_editor_params.merge(user_id: '') }
    end
    assert_template 'new'
    assert_response :success
  end

  # test 'should show survey_editor' do
  #   login(@builder)
  #   get :show, params: { survey_id: @survey, id: @survey_editor }
  #   assert_response :success
  # end

  test 'should get edit' do
    login(@builder)
    get :edit, params: { survey_id: @survey, id: @survey_editor }
    assert_response :success
  end

  test 'should update survey editor' do
    login(@builder)
    patch :update, params: { survey_id: @survey, id: @survey_editor, survey_editor: survey_editor_params }
    assert_redirected_to builder_survey_path(@survey)
  end

  test 'should not update survey editor without selected editor' do
    login(@builder)
    patch :update, params: { survey_id: @survey, id: @survey_editor, survey_editor: survey_editor_params.merge(user_id: '') }
    assert_template 'edit'
    assert_response :success
  end

  test 'should destroy survey editor' do
    login(@builder)
    assert_difference('SurveyEditor.count', -1) do
      delete :destroy, params: { survey_id: @survey, id: @survey_editor }
    end
    assert_redirected_to builder_survey_path(@survey)
  end
end
