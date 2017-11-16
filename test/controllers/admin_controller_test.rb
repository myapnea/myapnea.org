# frozen_string_literal: true

require 'test_helper.rb'

class AdminControllerTest < ActionController::TestCase
  setup do
    @owner = users(:owner)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  test 'should get providers as owner' do
    login(@owner)
    get :providers
    assert_not_nil assigns(:providers)
    assert_response :success
  end

  test 'should get progress report as owner' do
    login(@owner)
    get :progress_report
    assert_response :success
  end

  test 'should get dashboard as owner' do
    login(@owner)
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

  test 'should get admin surveys as owner' do
    login(users(:owner))
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

  test 'should unlock survey for user as owner' do
    login(users(:owner))
    post :unlock_survey, params: { user_id: users(:adult_diagnosed), answer_session_id: answer_sessions(:locked) }
    answer_sessions(:locked).reload
    assert_not_nil assigns(:user)
    assert_equal false, answer_sessions(:locked).locked?
    assert_redirected_to assigns(:user)
  end

  test 'should not unlock survey for without user as owner' do
    login(users(:owner))
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

  test 'should get location report as admin' do
    login(users(:moderator_1))
    get :location
    assert_response :success
  end

  test 'should get cross tabs as owner' do
    login(users(:owner))
    get :cross_tabs
    assert_response :success
  end

  test 'should only get social media for admin' do
    get :social_media
    assert_response :redirect
    login(users(:owner))
    get :social_media
    assert_response :success
  end

  test "should get spam inbox as owner" do
    login(users(:owner))
    get :spam_inbox
    assert_response :success
  end

  test "should empty spam as owner" do
    login(users(:owner))
    post :empty_spam
    assert_equal 0, User.current.where(shadow_banned: true).count
    assert_equal 0, Chapter.current.where(user: User.current.where(shadow_banned: true)).count
    assert_redirected_to admin_spam_inbox_path
  end

  test "should unshadowban user as owner" do
    login(users(:owner))
    assert_difference("User.where(shadow_banned: false).count") do
      post :unshadowban, params: { id: users(:shadow_banned).id }
    end
    assert_equal "Member un-shadowbanned successfully.", flash[:notice]
    assert_redirected_to admin_spam_inbox_path
  end
end
