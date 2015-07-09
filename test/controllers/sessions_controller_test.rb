require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "a user should be able to sign in" do
    user = users(:social)

    post :create, user: { email: user.email, password: "password" }

    assert_redirected_to root_path
  end

  test "a deleted user should not be able to sign in" do
    user = users(:deleted_user)

    post :create, user: { email: user.email, password: "password" }

    assert_redirected_to new_user_session_path
  end

end
