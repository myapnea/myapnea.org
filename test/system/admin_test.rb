# frozen_string_literal: true

require "application_system_test_case"

# System tests for internal pages.
class InternalTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin)
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

  test "visit admin dashboard" do
    visit_login(@admin)
    visit admin_url
    screenshot("visit-admin-dashboard")
    assert_selector "h1", text: "Admin Dashboard"
  end

  test "visit projects page" do
    visit_login(@admin)
    visit projects_url
    screenshot("visit-projects-page")
    assert_selector "h1", text: "Projects"
  end

  test "visit users page" do
    visit_login(@admin)
    visit users_url
    screenshot("visit-users-page")
    assert_selector "h1", text: "Users"
  end

  test "visit spam inbox" do
    visit_login(@admin)
    visit admin_spam_inbox_url
    screenshot("visit-spam-inbox")
    assert_selector "h1", text: "Spam Inbox"
    page.accept_confirm do
      click_on "Empty Spam"
    end
    screenshot("visit-spam-inbox")
    assert_selector "div", text: "Hurray, no spammers!"
  end

  test "visit member posts" do
    visit_login(@admin)
    visit admin_replies_url
    screenshot("visit-member-posts")
    assert_selector "h1", text: "Member Posts"
  end

  test "visit categories page" do
    visit_login(@admin)
    visit admin_categories_url
    screenshot("visit-categories-page")
    assert_selector "h1", text: "Categories"
  end

  test "visit images page" do
    skip
    visit_login(@admin)
    visit images_url
    screenshot("visit-images-page")
    assert_selector "h1", text: "Images"
  end

  test "visit exports page" do
    visit_login(@admin)
    visit admin_exports_url
    screenshot("visit-exports-page")
    assert_selector "h1", text: "Exports"
  end

  test "visit admin partners page" do
    visit_login(@admin)
    visit admin_partners_url
    screenshot("visit-admin-partners-page")
    assert_selector "h1", text: "Partners"
  end

  test "visit admin team members page" do
    visit_login(@admin)
    visit admin_team_members_url
    screenshot("visit-admin-team-members-page")
    assert_selector "h1", text: "Team Members"
  end
end
