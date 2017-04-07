# frozen_string_literal: true

require 'test_helper'

# Test to assure that survey editors can add and modify answer template answer
# options.
class Builder::AnswerOptionsControllerTest < ActionController::TestCase
  setup do
    @builder = users(:builder)
    @regular_user = users(:user_1)
    @survey = surveys(:built_on_web)
    @question = questions(:web_question)
    @answer_template = answer_templates(:web_answer_template)
    @answer_option = answer_options(:web_answer_template_01)
  end

  test 'should get answer options as builder' do
    login(@builder)
    get :index, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_redirected_to builder_survey_question_answer_template_path(assigns(:survey), assigns(:question), assigns(:answer_template))
  end

  test 'should not get answer options as regular user' do
    login(@regular_user)
    get :index, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_redirected_to root_path
  end

  test 'should get new answer option as builder' do
    login(@builder)
    get :new, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_response :success
  end

  test 'should not get new answer option as regular user' do
    login(@regular_user)
    get :new, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_nil assigns(:answer_option)
    assert_redirected_to root_path
  end

  test 'should create answer option as builder' do
    login(@builder)
    assert_difference('AnswerOption.count') do
      post :create, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, answer_option: { text: 'New Answer Option', hotkey: '1', value: '1' } }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_equal 'New Answer Option', assigns(:answer_option).text
    assert_equal '1', assigns(:answer_option).hotkey
    assert_equal 1, assigns(:answer_option).value
    assert_equal 2, @answer_template.answer_options_answer_templates.find_by(answer_option_id: assigns(:answer_option).id).position
    assert_redirected_to builder_survey_question_answer_template_answer_option_path(assigns(:survey), assigns(:question), assigns(:answer_template), assigns(:answer_option))
  end

  test 'should not create answer option without text' do
    login(@builder)
    assert_difference('AnswerOption.count', 0) do
      post :create, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, answer_option: { text: '', hotkey: '1', value: '1' } }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_equal ["can't be blank"], assigns(:answer_option).errors[:text]
    assert_template 'answer_options/new'
    assert_response :success
  end

  test 'should not create answer option as regular user' do
    login(@regular_user)
    assert_difference('AnswerOption.count', 0) do
      post :create, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, answer_option: { text: 'New Answer Option', hotkey: '1', value: '1' } }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_nil assigns(:answer_option)
    assert_redirected_to root_path
  end

  test 'should show answer option as builder' do
    login(@builder)
    get :show, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_response :success
  end

  test 'should not show answer option as regular user' do
    login(@regular_user)
    get :show, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_nil assigns(:answer_option)
    assert_redirected_to root_path
  end

  test 'should get edit answer option as builder' do
    login(@builder)
    get :edit, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_response :success
  end

  test 'should not get edit answer option as regular user' do
    login(@regular_user)
    get :edit, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_nil assigns(:answer_option)
    assert_redirected_to root_path
  end

  test 'should update answer option as builder' do
    login(@builder)
    patch :update, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option, answer_option: { text: 'Updated Answer Option', hotkey: '2', value: '2' } }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_equal 'Updated Answer Option', assigns(:answer_option).text
    assert_equal '2', assigns(:answer_option).hotkey
    assert_equal 2, assigns(:answer_option).value
    assert_redirected_to builder_survey_question_answer_template_answer_option_path(assigns(:survey), assigns(:question), assigns(:answer_template), assigns(:answer_option))
  end

  test 'should not update answer option without name' do
    login(@builder)
    patch :update, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option, answer_option: { text: '', hotkey: '2', value: '2' } }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_equal ["can't be blank"], assigns(:answer_option).errors[:text]
    assert_template 'answer_options/edit'
    assert_response :success
  end

  test 'should not update answer option as regular user' do
    login(@regular_user)
    patch :update, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option, answer_option: { text: 'Updated Answer Option', hotkey: '2', value: '2' } }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_nil assigns(:answer_option)
    assert_redirected_to root_path
  end

  test 'should destroy answer option as builder' do
    login(@builder)
    assert_difference('AnswerOption.current.count', -1) do
      delete :destroy, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_not_nil assigns(:answer_option)
    assert_redirected_to builder_survey_question_answer_template_path(assigns(:survey), assigns(:question), assigns(:answer_template))
  end

  test 'should not destroy answer option as regular user' do
    login(@regular_user)
    assert_difference('AnswerOption.current.count', 0) do
      delete :destroy, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, id: @answer_option }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_nil assigns(:answer_option)
    assert_redirected_to root_path
  end

  test 'should save option order' do
    login(@builder)
    post :reorder, params: { survey_id: @survey, question_id: @question, answer_template_id: @answer_template, answer_option_ids: [ActiveRecord::FixtureSet.identify(:web_answer_template_02), ActiveRecord::FixtureSet.identify(:web_answer_template_01)] }, format: 'js'
    assert_response :success
  end
end
