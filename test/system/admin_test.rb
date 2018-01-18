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
end
