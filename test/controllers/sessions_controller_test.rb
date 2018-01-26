# frozen_string_literal: true

require "test_helper"

# Test to assure users can sign in.
class SessionsControllerTest < ActionController::TestCase
  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "a user should be able to sign in" do
    user = users(:regular)
    post :create, params: { user: { email: user.email, password: "password" } }
    assert_redirected_to dashboard_path
  end

  test "a deleted user should not be able to sign in" do
    user = users(:deleted)
    post :create, params: { user: { email: user.email, password: "password" } }
    assert_redirected_to new_user_session_path
  end
end
