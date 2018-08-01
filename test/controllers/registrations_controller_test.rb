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

  test "should consent to study and sign up new user" do
    post slice_enrollment_consent_url(projects(:one)), params: {
      user: {
        full_name: "Joe Smith"
      }
    }
    assert_redirected_to new_user_registration_url
    assert_difference("Subject.count") do
      assert_difference("User.count") do
        post user_registration_url, params: {
          user: {
            username: "JoeSmith",
            email: "joe_smith@example.com",
            password: "password"
          }
        }
      end
    end
    assert_equal projects(:one), Subject.last.project
    assert_equal User.last, Subject.last.user
    assert_equal "Joe Smith", User.last.full_name
    assert_redirected_to root_url
  end

  test "should consent to study and sign up existing user" do
    post slice_enrollment_consent_url(projects(:one)), params: {
      user: {
        full_name: "Joe Smith"
      }
    }
    assert_redirected_to new_user_registration_url
    # Navigate to user login for existing account.
    password = "123334567890"
    @unconsented = users(:unconsented)
    @unconsented.update password: password, password_confirmation: password
    assert_difference("Subject.count") do
      post new_user_session_url, params: {
        user: { email: @unconsented.email, password: password }
      }
    end
    @unconsented.reload
    assert_equal projects(:one), Subject.last.project
    assert_equal @unconsented, Subject.last.user
    assert_equal "Joe Smith", @unconsented.full_name
    assert_redirected_to slice_overview_url(projects(:one))
  end
end
