# frozen_string_literal: true

require "test_helper"

# Test to assure users can sign in.
class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "a user should be able to sign in" do
    user = users(:regular)
    post new_user_session_url, params: { user: { email: user.email, password: "password" } }
    assert_redirected_to dashboard_url
  end

  test "a deleted user should not be able to sign in" do
    user = users(:deleted)
    post new_user_session_url, params: { user: { email: user.email, password: "password" } }
    assert_redirected_to new_user_session_url
  end
end
