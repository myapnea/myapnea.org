# frozen_string_literal: true

require 'test_helper'

# Test to assure that interal pages load properly for users.
class InternalControllerTest < ActionDispatch::IntegrationTest
  def setup
    @regular_user = users(:user_1)
  end

  test 'should get dashboard' do
    skip
    sign_in_as(@regular_user, 'password')
    get dashboard_path
    assert_response :success
  end

  test 'should get dashboard1' do
    sign_in_as(@regular_user, 'password')
    get dashboard1_path
    assert_response :success
  end

  test 'should get dashboard2' do
    sign_in_as(@regular_user, 'password')
    get dashboard2_path
    assert_response :success
  end

  test 'should get dashboard3' do
    sign_in_as(@regular_user, 'password')
    get dashboard3_path
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

  test 'should get settings emails' do
    sign_in_as(@regular_user, 'password')
    get settings_emails_path
    assert_response :success
  end
end
