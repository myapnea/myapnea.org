# frozen_string_literal: true

require "test_helper"

# Test user settings pages.
class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @regular = users(:user_1)
  end

  test "should get settings" do
    login(@regular)
    get settings_url
    assert_redirected_to settings_profile_url
  end

  test "should get profile for regular user" do
    login(@regular)
    get settings_profile_url
    assert_response :success
  end

  test "should not get profile for public user" do
    get settings_profile_url
    assert_redirected_to new_user_session_url
  end

  test "should update profile" do
    login(@regular)
    patch settings_update_profile_url, params: {
      user: {
        forum_name: "ForumNameUpdate",
        profile_bio: "Short Bio",
        profile_location: "Boston, MA"
      }
    }
    @regular.reload
    assert_equal "ForumNameUpdate", @regular.forum_name
    assert_equal "Short Bio", @regular.profile_bio
    assert_equal "Boston, MA", @regular.profile_location
    assert_equal "Profile successfully updated.", flash[:notice]
    assert_redirected_to settings_profile_url
  end

  test "should update profile picture" do
    login(@regular)
    patch settings_update_profile_picture_url, params: {
      user: {
        photo: fixture_file_upload("../../test/support/images/rails.png")
      }
    }
    @regular.reload
    assert_equal true, @regular.photo.present?
    assert_equal "Profile picture successfully updated.", flash[:notice]
    assert_redirected_to settings_profile_url
  end

  test "should get account" do
    login(@regular)
    get settings_account_url
    assert_response :success
  end

  test "should update account" do
    login(@regular)
    patch settings_update_account_url, params: {
      user: { first_name: "First Update", last_name: "Last Update" }
    }
    @regular.reload
    assert_equal "First Update", @regular.first_name
    assert_equal "Last Update", @regular.last_name
    assert_equal "Account successfully updated.", flash[:notice]
    assert_redirected_to settings_account_url
  end

  test "should update password" do
    sign_in_as(@regular, "password")
    patch settings_update_password_url, params: {
      user: {
        current_password: "password",
        password: "newpassword",
        password_confirmation: "newpassword"
      }
    }
    assert_equal "Your password has been changed.", flash[:notice]
    assert_redirected_to settings_account_url
  end

  test "should not update password as user with invalid current password" do
    sign_in_as(@regular, "password")
    patch settings_update_password_url, params: {
      user: {
        current_password: "invalid",
        password: "newpassword",
        password_confirmation: "newpassword"
      }
    }
    assert_template "account"
    assert_response :success
  end

  test "should not update password with new password mismatch" do
    sign_in_as(@regular, "password")
    patch settings_update_password_url, params: {
      user: {
        current_password: "password",
        password: "newpassword",
        password_confirmation: "mismatched"
      }
    }
    assert_template "account"
    assert_response :success
  end

  test "should delete account" do
    login(@regular)
    assert_difference("User.current.count", -1) do
      delete settings_delete_account_url
    end
    assert_redirected_to root_url
  end

  test "should get email" do
    login(@regular)
    get settings_email_url
    assert_response :success
  end

  test "should update email" do
    login(@regular)
    patch settings_update_email_url, params: { user: { email: "newemail@example.com" } }
    @regular.reload
    assert_equal "newemail@example.com", @regular.email
    assert_equal "Email successfully updated.", flash[:notice]
    assert_redirected_to settings_email_url
  end
end
