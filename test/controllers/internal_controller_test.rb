# frozen_string_literal: true

require "test_helper"

# Test to assure that interal pages load properly for users.
class InternalControllerTest < ActionDispatch::IntegrationTest
  def setup
    @regular_user = users(:user_1)
  end

  test "should get dashboard" do
    login(@regular_user)
    get dashboard_url
    assert_response :success
  end

  test "should get dashboard reports" do
    login(@regular_user)
    get reports_url
    assert_response :success
  end

  test "should get timeline" do
    login(@regular_user)
    get timeline_url
    assert_response :success
  end

  test "should get research" do
    login(@regular_user)
    get research_url
    assert_response :success
  end

  test "should get settings" do
    login(@regular_user)
    get settings_url
    assert_redirected_to settings_profile_url
  end

  test "should get settings account" do
    login(@regular_user)
    get settings_account_url
    assert_response :success
  end

  test "should get settings consents" do
    login(@regular_user)
    get settings_consents_url
    assert_response :success
  end
end
