# frozen_string_literal: true

require 'test_helper'

class Api::V1::SurveysControllerTest < ActionController::TestCase

  setup do
    @user = users(:api_user)
    @answer_session = answer_sessions(:api_user)
    @survey = surveys(:new)
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "should get survey show for logged in user" do
    login(@user)
    get :show, id: @survey.id, format: :json
    assert_response :success
    assert_not_nil assigns(:answer_session)
  end

  test "should get answer sessions for logged in user" do
    login(users(:has_completed_survey))
    get :answer_sessions, format: :json

    assert_not_nil json_response['answer_sessions']
    assert_response :success
  end

  test "should not get answer sessions for logged in user" do
    get :answer_sessions, format: :json
    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  test "should process answer" do
    login(@user)
    post :process_answer, answer_session_id: @answer_session, question_id: questions(:radio1), response: { answer_templates(:custom_sex_template).to_param => answer_options(:male).id }, format: :json

    assert_equal true, json_response['success']
    assert_equal false, json_response['survey_complete']
  end

  test "should not process answer for nonexistent parameters" do
    login(@user)
    post :process_answer, answer_session_id: @answer_session, question_id: 88888, response: { answer_templates(:custom_sex_template).to_param => answer_options(:male).id }, format: :json

    assert_equal false, json_response['success']
  end

  test "should process answer and mark survey as complete then lock" do
    login(@user)
    post :process_answer, answer_session_id: @answer_session, question_id: questions(:date2), response: { answer_templates(:date2).to_param => { month: '01', day: '01', year: '1950' } }, format: :json

    assert_equal true, json_response['success']
    assert_equal true, json_response['survey_complete']

    post :lock_answer_session, answer_session_id: @answer_session, format: :json

    assert_equal true, json_response['success']
  end

end
