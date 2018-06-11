# frozen_string_literal: true

require "test_helper"

# Tests to assure that users can register on the site.
class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def user_params
    {
      username: "SleepyDuck",
      email: "new_user@example.com",
      password: "password"
    }
  end

  test "should sign up new user" do
    assert_difference("User.count") do
      post user_registration_url, params: {
        user: user_params
      }
    end
    assert_not_nil assigns(:user)
    assert_equal "SleepyDuck", assigns(:user).username
    assert_equal "new_user@example.com", assigns(:user).email
    assert_redirected_to root_url
  end

  test "should not sign up new user without required fields" do
    assert_difference("User.count", 0) do
      post user_registration_url, params: {
        user: user_params.merge(username: "", email: "", password: "")
      }
    end
    assert_not_nil assigns(:user)
    assert_equal ["can't be blank"], assigns(:user).errors[:username]
    assert_equal ["can't be blank"], assigns(:user).errors[:email]
    assert_equal ["can't be blank"], assigns(:user).errors[:password]
    assert_template "devise/registrations/new"
    assert_response :success
  end
end
