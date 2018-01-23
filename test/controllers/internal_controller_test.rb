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

  test "should get timeline" do
    login(@regular_user)
    get timeline_url
    assert_response :success
  end

  test "should get settings" do
    login(@regular_user)
    get settings_url
    assert_redirected_to settings_profile_url
  end
end
