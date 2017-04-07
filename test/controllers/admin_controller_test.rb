# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure admin can view reports.
class AdminControllerTest < ActionController::TestCase
  setup do
    @admin = users(:admin)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  test 'should get progress report as admin' do
    login(@admin)
    get :progress_report
    assert_response :success
  end

  test 'should get dashboard as admin' do
    login(@admin)
    get :dashboard
    assert_response :success
  end

  test 'should get dashboard as moderator' do
    login(@moderator)
    get :dashboard
    assert_response :success
  end

  test 'should not get dashboard as regular user' do
    login(@regular_user)
    get :dashboard
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test 'should not get dashboard as logged out user' do
    get :dashboard
    assert_redirected_to new_user_session_path
  end

  test 'should get admin surveys as admin' do
    login(users(:admin))
    get :surveys
    assert_response :success
  end

  test 'should get admin surveys as moderator' do
    login(users(:moderator_1))
    get :surveys
    assert_response :success
  end

  test 'should not get admin surveys for regular user' do
    login(users(:user_1))
    get :surveys
    assert_redirected_to root_path
  end

  test 'should unlock survey for user as admin' do
    login(users(:admin))
    post :unlock_survey, params: { user_id: users(:adult_diagnosed), answer_session_id: answer_sessions(:locked) }
    answer_sessions(:locked).reload
    assert_not_nil assigns(:user)
    assert_equal false, answer_sessions(:locked).locked?
    assert_redirected_to assigns(:user)
  end

  test 'should not unlock survey for without user as admin' do
    login(users(:admin))
    post :unlock_survey, params: { user_id: -1, answer_session_id: answer_sessions(:locked) }
    answer_sessions(:locked).reload
    assert_nil assigns(:user)
    assert_equal true, answer_sessions(:locked).locked?
    assert_redirected_to users_path
  end

  test 'should unlock survey for user as moderator' do
    login(users(:moderator_1))
    post :unlock_survey, params: { user_id: users(:adult_diagnosed), answer_session_id: answer_sessions(:locked) }
    answer_sessions(:locked).reload
    assert_not_nil assigns(:user)
    assert_equal false, answer_sessions(:locked).locked?
    assert_redirected_to assigns(:user)
  end

  test 'should not unlock survey for user as regular user' do
    login(users(:user_1))
    post :unlock_survey, params: { user_id: users(:adult_diagnosed), answer_session_id: answer_sessions(:locked) }
    answer_sessions(:locked).reload
    assert_nil assigns(:user)
    assert_equal true, answer_sessions(:locked).locked?
    assert_redirected_to root_path
  end

  test 'should get admin timeline report as admin' do
    login(users(:moderator_1))
    get :timeline
    assert_response :success
  end

  test 'should get cross tabs as admin' do
    login(users(:admin))
    get :cross_tabs
    assert_response :success
  end
end
