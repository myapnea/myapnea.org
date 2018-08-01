# frozen_string_literal: true

require "test_helper"

# Test to assure users can sign in.
class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @regular = users(:regular)
    @deleted = users(:deleted)
  end

  test "a user should be able to sign in" do
    post new_user_session_url, params: { user: { email: @regular.email, password: "password" } }
    assert_redirected_to dashboard_url
  end

  test "a deleted user should not be able to sign in" do
    post new_user_session_url, params: { user: { email: @deleted.email, password: "password" } }
    assert_redirected_to new_user_session_url
  end

  test "should redirect to dashboard after visiting landing page" do
    get landing_url
    post new_user_session_url, params: { user: { email: @regular.email, password: "password" } }
    assert_redirected_to dashboard_url
  end

  test "should stay on forum after signing in" do
    get topics_url
    post new_user_session_url, params: { user: { email: @regular.email, password: "password" } }
    assert_redirected_to topics_url
  end

  test "should redirect to landing page after signing out from dashboard" do
    login(@regular)
    get dashboard_url
    get destroy_user_session_path
    assert_redirected_to root_url
  end

  test "should stay on forum after signing out" do
    login(@regular)
    get topics_url
    get destroy_user_session_path
    assert_redirected_to topics_url
  end
end
