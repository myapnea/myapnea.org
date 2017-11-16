# frozen_string_literal: true

require "test_helper"

# Tests to assure that users can register on the site.
class RegistrationsControllerTest < ActionController::TestCase
  def user_params
    {
      first_name: "First Name",
      last_name: "Last Name",
      over_eighteen: true,
      email: "new_user@example.com",
      password: "password"
    }
  end

  test "should sign up new user" do
    request.env["devise.mapping"] = Devise.mappings[:user]
    assert_difference("User.count") do
      post :create, params: {
        user: user_params
      }
    end
    assert_not_nil assigns(:user)
    assert_equal "First Name", assigns(:user).first_name
    assert_equal "Last Name", assigns(:user).last_name
    assert_equal true, assigns(:user).over_eighteen?
    assert_equal "new_user@example.com", assigns(:user).email
    assert_redirected_to dashboard_path
  end

  test "should not sign up new user without required fields" do
    request.env["devise.mapping"] = Devise.mappings[:user]
    assert_difference("User.count", 0) do
      post :create, params: {
        user: user_params.merge(first_name: "", last_name: "", email: "", password: "")
      }
    end
    assert_not_nil assigns(:user)
    assert_equal ["can't be blank"], assigns(:user).errors[:first_name]
    assert_equal ["can't be blank"], assigns(:user).errors[:last_name]
    assert_equal ["can't be blank"], assigns(:user).errors[:email]
    assert_equal ["can't be blank"], assigns(:user).errors[:password]
    assert_template "devise/registrations/new"
    assert_response :success
  end

  test "should not sign up new user without meeting minimum age requirements" do
    request.env["devise.mapping"] = Devise.mappings[:user]
    assert_difference("User.count", 0) do
      post :create, params: {
        user: user_params.merge(over_eighteen: false)
      }
    end
    assert_not_nil assigns(:user)
    assert_template "devise/registrations/new"
    assert_response :success
  end
end
