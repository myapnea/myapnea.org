# frozen_string_literal: true

require 'test_helper'

# Test to assure that survey editors can add and modify survey questions.
class Builder::QuestionsControllerTest < ActionController::TestCase
  setup do
    @builder = users(:builder)
    @regular_user = users(:user_1)
    @survey = surveys(:built_on_web)
    @question = questions(:web_question)
  end

  test 'should get questions as builder' do
    login(@builder)
    get :index, params: { survey_id: @survey }
    assert_not_nil assigns(:survey)
    assert_redirected_to builder_survey_path(assigns(:survey))
  end

  test 'should not get questions as regular user' do
    login(@regular_user)
    get :index, params: { survey_id: @survey }
    assert_nil assigns(:survey)
    assert_redirected_to root_path
  end

  test 'should get new question as builder' do
    login(@builder)
    get :new, params: { survey_id: @survey }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_response :success
  end

  test 'should not get new question as regular user' do
    login(@regular_user)
    get :new, params: { survey_id: @survey }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'should create question as builder' do
    login(@builder)
    assert_difference('Question.count') do
      post :create, params: { survey_id: @survey, question: { text_en: 'My New Question', slug: 'my-new-question' } }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_equal 'My New Question', assigns(:question).text_en
    assert_equal 'my-new-question', assigns(:question).slug
    assert_equal 1, @survey.survey_question_orders.find_by(question_id: assigns(:question).id).position
    assert_redirected_to builder_survey_question_path(assigns(:survey), assigns(:question))
  end

  test 'should not create question without text' do
    login(@builder)
    assert_difference('Question.count', 0) do
      post :create, params: { survey_id: @survey, question: { text_en: '', slug: 'my-new-question' } }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert assigns(:question).errors.size > 0
    assert_equal ["can't be blank"], assigns(:question).errors[:text_en]
    assert_template 'questions/new'
    assert_response :success
  end

  test 'should not create question as regular user' do
    login(@regular_user)
    assert_difference('Question.count', 0) do
      post :create, params: { survey_id: @survey, question: { text_en: 'My New Question', slug: 'my-new-question' } }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'should show question as builder' do
    login(@builder)
    get :show, params: { survey_id: @survey, id: @question }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_response :success
  end

  test 'should not show question as regular user' do
    login(@regular_user)
    get :show, params: { survey_id: @survey, id: @question }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'should get edit question as builder' do
    login(@builder)
    get :edit, params: { survey_id: @survey, id: @question }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_response :success
  end

  test 'should not get edit question as regular user' do
    login(@regular_user)
    get :edit, params: { survey_id: @survey, id: @question }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'should update question as builder' do
    login(@builder)
    patch :update, params: { survey_id: @survey, id: @question, question: { text_en: 'Updated Question', slug: 'updated-question' } }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_equal 'Updated Question', assigns(:question).text_en
    assert_equal 'updated-question', assigns(:question).slug
    assert_redirected_to builder_survey_question_path(assigns(:survey), assigns(:question))
  end

  test 'should not update question without name' do
    login(@builder)
    patch :update, params: { survey_id: @survey, id: @question, question: { text_en: '', slug: 'updated-question' } }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert assigns(:question).errors.size > 0
    assert_equal ["can't be blank"], assigns(:question).errors[:text_en]
    assert_template 'questions/edit'
    assert_response :success
  end

  test 'should not update question as regular user' do
    login(@regular_user)
    patch :update, params: { survey_id: @survey, id: @question, question: { text_en: 'Updated Question', slug: 'updated-question' } }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'should destroy question as builder' do
    login(@builder)
    assert_difference('Question.current.count', -1) do
      delete :destroy, params: { survey_id: @survey, id: @question }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_redirected_to builder_survey_path(assigns(:survey))
  end

  test 'should not destroy question as regular user' do
    login(@regular_user)
    assert_difference('Question.current.count', 0) do
      delete :destroy, params: { survey_id: @survey, id: @question }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test 'should save question order' do
    login(@builder)
    post :reorder, params: { survey_id: @survey, question_ids: [ActiveRecord::FixtureSet.identify(:web_question)] }, format: 'js'
    assert_response :success
  end
end
