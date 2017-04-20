# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure admin can view reports.
class AdminControllerTest < ActionController::TestCase
  setup do
    @admin = users(:admin)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
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
end
