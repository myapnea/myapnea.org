# frozen_string_literal: true

require "application_system_test_case"

# System tests for Slice subjects.
class SubjectsTest < ApplicationSystemTestCase
  setup do
    @subject = subjects(:one)
    @regular = users(:valid)
  end

  def visit_login(user, screenshot_name)
    password = "PASSword2"
    user.update(password: password, password_confirmation: password)
    visit root_url
    screenshot(screenshot_name)
    click_on "Sign in"
    screenshot(screenshot_name)
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    click_form_submit
  end

  test "visiting the index" do
    visit_login(@regular, "subject_index")
    visit slice_subjects_url
    assert_selector "h1", text: "Subjects"
  end

  test "creating a Subject" do
    visit_login(@regular, "subject_create")
    visit slice_subjects_url
    click_on "New Subject"
    fill_in "subject[project_id]", with: projects(:two).id
    click_on "Create Subject"

    assert_text "Subject was successfully created"
  end

  test "updating a Subject" do
    visit_login(@regular, "subject_update")
    visit slice_subjects_url
    click_on "Edit", match: :first

    click_on "Update Subject"

    assert_text "Subject was successfully updated"
  end

  test "destroying a Subject" do
    visit_login(@regular, "subject_destroy")
    visit slice_subjects_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Subject was successfully deleted"
  end
end
