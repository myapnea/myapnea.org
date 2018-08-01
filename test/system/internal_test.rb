# frozen_string_literal: true

require "application_system_test_case"

# System tests for internal pages.
class InternalTest < ApplicationSystemTestCase
  setup do
    @regular = users(:regular)
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
