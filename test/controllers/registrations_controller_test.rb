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
    assert_equal "SleepyDuck", User.last.username
    assert_equal "new_user@example.com", User.last.email
    assert_redirected_to root_url
  end

  test "should not sign up new user without username" do
    assert_difference("User.count", 0) do
      post user_registration_url, params: {
        user: user_params.merge(username: "")
      }
    end
    assert_response :success
  end

  test "should not sign up new user without email" do
    assert_difference("User.count", 0) do
      post user_registration_url, params: {
        user: user_params.merge(email: "")
      }
    end
    assert_response :success
  end

  test "should not sign up new user without password" do
    assert_difference("User.count", 0) do
      post user_registration_url, params: {
        user: user_params.merge(password: "")
      }
    end
    assert_response :success
  end
end
