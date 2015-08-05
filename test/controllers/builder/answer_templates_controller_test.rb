require 'test_helper'

class Builder::AnswerTemplatesControllerTest < ActionController::TestCase
  setup do
    @builder = users(:builder)
    @regular_user = users(:user_1)
    @survey = surveys(:built_on_web)
    @question = questions(:web_question)
    @answer_template = answer_templates(:web_answer_template)
  end

  test "should get answer templates as builder" do
    login(@builder)
    get :index, survey_id: @survey, question_id: @question
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_redirected_to builder_survey_question_path(assigns(:survey), assigns(:question))
  end

  test "should not get answer templates as regular user" do
    login(@regular_user)
    get :index, survey_id: @survey, question_id: @question
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_redirected_to root_path
  end

  test "should get new answer template as builder" do
    login(@builder)
    get :new, survey_id: @survey, question_id: @question
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_response :success
  end

  test "should not get new answer template as regular user" do
    login(@regular_user)
    get :new, survey_id: @survey, question_id: @question
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_redirected_to root_path
  end

  test "should create answer template as builder" do
    login(@builder)
    assert_difference('AnswerTemplate.count') do
      post :create, survey_id: @survey, question_id: @question, answer_template: { name: 'My New Answer Template', template_name: 'checkbox', target_answer_option: @answer_template.target_answer_option, text: @answer_template.text }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_equal 'My New Answer Template', assigns(:answer_template).name
    assert_equal 'checkbox', assigns(:answer_template).template_name
    assert_equal 'answer_option_id', assigns(:answer_template).data_type
    assert_equal true, assigns(:answer_template).allow_multiple
    assert_redirected_to builder_survey_question_answer_template_path(assigns(:survey), assigns(:question), assigns(:answer_template))
  end

  test "should not create answer template without text" do
    login(@builder)
    assert_difference('AnswerTemplate.count', 0) do
      post :create, survey_id: @survey, question_id: @question, answer_template: { name: '', template_name: 'checkbox', target_answer_option: @answer_template.target_answer_option, text: @answer_template.text }
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert assigns(:answer_template).errors.size > 0
    assert_equal ["can't be blank"], assigns(:answer_template).errors[:name]
    assert_template 'answer_templates/new'
    assert_response :success
  end

  test "should not create answer template as regular user" do
    login(@regular_user)
    assert_difference('AnswerTemplate.count', 0) do
      post :create, survey_id: @survey, question_id: @question, answer_template: { name: 'My New Answer Template', template_name: 'checkbox', target_answer_option: @answer_template.target_answer_option, text: @answer_template.text }
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_redirected_to root_path
  end

  test "should show answer template as builder" do
    login(@builder)
    get :show, survey_id: @survey, question_id: @question, id: @answer_template
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_response :success
  end

  test "should not show answer template as regular user" do
    login(@regular_user)
    get :show, survey_id: @survey, question_id: @question, id: @answer_template
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_redirected_to root_path
  end

  test "should get edit answer template as builder" do
    login(@builder)
    get :edit, survey_id: @survey, question_id: @question, id: @answer_template
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_response :success
  end

  test "should not get edit answer template as regular user" do
    login(@regular_user)
    get :edit, survey_id: @survey, question_id: @question, id: @answer_template
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_redirected_to root_path
  end

  test "should update answer template as builder" do
    login(@builder)
    patch :update, survey_id: @survey, question_id: @question, id: @answer_template, answer_template: { name: 'Updated Answer Template', template_name: 'date', target_answer_option: @answer_template.target_answer_option, text: @answer_template.text }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_equal 'Updated Answer Template', assigns(:answer_template).name
    assert_equal 'date', assigns(:answer_template).template_name
    assert_equal 'text_value', assigns(:answer_template).data_type
    assert_equal false, assigns(:answer_template).allow_multiple
    assert_redirected_to builder_survey_question_answer_template_path(assigns(:survey), assigns(:question), assigns(:answer_template))
  end

  test "should not update answer template without name" do
    login(@builder)
    patch :update, survey_id: @survey, question_id: @question, id: @answer_template, answer_template: { name: '', template_name: 'date', target_answer_option: @answer_template.target_answer_option, text: @answer_template.text }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert assigns(:answer_template).errors.size > 0
    assert_equal ["can't be blank"], assigns(:answer_template).errors[:name]
    assert_template 'answer_templates/edit'
    assert_response :success
  end

  test "should not update answer template as regular user" do
    login(@regular_user)
    patch :update, survey_id: @survey, question_id: @question, id: @answer_template, answer_template: { name: 'Updated Answer Template', template_name: 'date', target_answer_option: @answer_template.target_answer_option, text: @answer_template.text }
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_redirected_to root_path
  end

  test "should destroy answer template as builder" do
    login(@builder)
    assert_difference('AnswerTemplate.current.count', -1) do
      delete :destroy, survey_id: @survey, question_id: @question, id: @answer_template
    end
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:question)
    assert_not_nil assigns(:answer_template)
    assert_redirected_to builder_survey_question_path(assigns(:survey), assigns(:question))
  end

  test "should not destroy answer template as regular user" do
    login(@regular_user)
    assert_difference('AnswerTemplate.current.count', 0) do
      delete :destroy, survey_id: @survey, question_id: @question, id: @answer_template
    end
    assert_nil assigns(:survey)
    assert_nil assigns(:question)
    assert_nil assigns(:answer_template)
    assert_redirected_to root_path
  end

end
