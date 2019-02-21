# frozen_string_literal: true

require "application_system_test_case"

# System tests for joining the research study.
class ResearchTest < ApplicationSystemTestCase
  setup do
    @unconsented = users(:unconsented)
  end

  test "consent new user" do
    visit slice_research_url
    click_on "Get started", match: :first
    screenshot("consent-new-user")
    fill_in "user[full_name]", with: "Joe Smith"
    screenshot("consent-new-user")
    click_on "I Consent"
    screenshot("consent-new-user")
    assert_selector "div", text: "Join our community."
    fill_in "user[username]", with: "AmicableRaven"
    fill_in "user[email]", with: "jsmith@example.com"
    fill_in "user[password]", with: "longpassword"
    screenshot("consent-new-user")
    click_on "Next step"
    assert_equal "AmicableRaven", User.last.username
    assert_equal "jsmith@example.com", User.last.email
    assert_equal true, User.last.subjects.first.consented_at.present?
    screenshot("consent-new-user")
    assert_selector "div", text: I18n.t("devise.registrations.signed_up_but_unconfirmed")
  end

  test "consent existing signed in user" do
    visit_login(@unconsented)
    visit slice_research_url
    screenshot("consent-existing-signed-in-user")
    click_on "Get started", match: :first
    screenshot("consent-existing-signed-in-user")
    fill_in "user[full_name]", with: "Joe Smith"
    screenshot("consent-existing-signed-in-user")
    click_on "I Consent"
    assert_selector "div", text: "Thank you for agreeing to participate in the MyApnea research study!"
    @unconsented.reload
    assert_equal true, @unconsented.subjects.first.consented_at.present?
    screenshot("consent-existing-signed-in-user")
  end

  test "consent existing signed out user" do
    visit slice_research_url
    screenshot("consent-existing-signed-out-user")
    click_on "Get started", match: :first
    screenshot("consent-existing-signed-out-user")
    fill_in "user[full_name]", with: "Joe Smith"
    screenshot("consent-existing-signed-out-user")
    click_on "I Consent"
    assert_selector "div", text: "Join our community."
    screenshot("consent-existing-signed-out-user")
    click_on "I already have an account"
    screenshot("consent-existing-signed-out-user")
    password = "password"
    @unconsented.update(password: password, password_confirmation: password)
    fill_in "user[email]", with: @unconsented.email
    fill_in "user[password]", with: password
    screenshot("consent-existing-signed-out-user")
    click_form_submit
    assert_equal true, @unconsented.subjects.first.consented_at.present?
    assert_selector "div", text: "Thank you for agreeing to participate in the MyApnea research study!"
    screenshot("consent-existing-signed-out-user")
  end
end
