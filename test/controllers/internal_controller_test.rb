# frozen_string_literal: true

require 'test_helper'

# Test to assure that interal pages load properly for users.
class InternalControllerTest < ActionDispatch::IntegrationTest
  def setup
    @regular_user = users(:user_1)
  end

  test 'should get dashboard' do
    sign_in_as(@regular_user, 'password')
    get dashboard_path
    assert_redirected_to activity_path
  end

  test 'should get dashboard activity' do
    sign_in_as(@regular_user, 'password')
    get activity_path
    assert_response :success
  end

  test 'should get dashboard research' do
    sign_in_as(@regular_user, 'password')
    get research_path
    assert_response :success
  end

  test 'should get dashboard reports' do
    sign_in_as(@regular_user, 'password')
    get reports_path
    assert_response :success
  end

  test 'should get timeline' do
    sign_in_as(@regular_user, 'password')
    get timeline_path
    assert_response :success
  end

  test 'should get research' do
    sign_in_as(@regular_user, 'password')
    get research_path
    assert_response :success
  end

  test 'should get settings' do
    sign_in_as(@regular_user, 'password')
    get settings_path
    assert_redirected_to settings_profile_path
  end

  test 'should get settings account' do
    sign_in_as(@regular_user, 'password')
    get settings_account_path
    assert_response :success
  end

  test 'should get settings consents' do
    sign_in_as(@regular_user, 'password')
    get settings_consents_path
    assert_response :success
  end
end
