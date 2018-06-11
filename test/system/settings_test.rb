# frozen_string_literal: true

require "application_system_test_case"

# System tests for internal pages.
class InternalTest < ApplicationSystemTestCase
  setup do
    @regular = users(:regular)
  end

  def visit_login(user, screenshot_name = nil)
    password = "PASSword2"
    user.update(password: password, password_confirmation: password)
    visit new_user_session_url
    screenshot(screenshot_name) if screenshot_name.present?
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    click_form_submit
  end

  test "visit account settings" do
    visit_login(@regular)
    visit settings_account_url
    screenshot("visit-settings-account")
    assert_selector "h1", text: "Account Settings"
  end

  test "visit email settings" do
    visit_login(@regular)
    visit settings_email_url
    screenshot("visit-settings-email")
    assert_selector "h1", text: "Email Settings"
  end

  test "visit profile settings" do
    visit_login(@regular)
    visit settings_profile_url
    screenshot("visit-settings-profile")
    assert_selector "h1", text: "Profile Settings"
  end

  test "visit notification settings" do
    visit_login(@regular)
    visit settings_notifications_url
    screenshot("visit-settings-notifications")
    assert_selector "h1", text: "Notification Settings"
  end
end
