# frozen_string_literal: true

require "test_helper"

# Test user settings pages.
class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @regular = users(:regular)
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
        username: "ForumNameUpdate",
        profile_bio: "Short Bio",
        profile_location: "Boston, MA"
      }
    }
    @regular.reload
    assert_equal "ForumNameUpdate", @regular.username
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
      user: { full_name: "FirstUpdate LastUpdate" }
    }
    @regular.reload
    assert_equal "FirstUpdate LastUpdate", @regular.full_name
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
    assert_equal "regular@example.com", @regular.email
    assert_equal "newemail@example.com", @regular.unconfirmed_email
    assert_equal I18n.t("devise.confirmations.send_instructions"), flash[:notice]
    assert_redirected_to settings_email_url
  end

  test "should get notification settings" do
    login(@regular)
    get settings_notifications_url
    assert_response :success
  end

  test "should update notification settings" do
    login(@regular)
    patch settings_update_notifications_url, params: { user: { forum_auto_subscribed: "1" } }
    @regular.reload
    assert_equal true, @regular.forum_auto_subscribed?
    assert_equal "Notifications successfully updated.", flash[:notice]
    assert_redirected_to settings_notifications_url
  end
end
