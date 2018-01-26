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

  test "visit dashboard" do
    visit_login(@regular)
    visit dashboard_url
    screenshot("visit-dashboard")
    assert_selector "h1", text: "My Dashboard"
  end

  test "visit notifications" do
    visit_login(@regular)
    visit notifications_url
    screenshot("visit-notifications")
    assert_selector "h1", text: "Notifications"
  end
end
