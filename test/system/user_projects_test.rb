require "application_system_test_case"

class UserProjectsTest < ApplicationSystemTestCase
  setup do
    @user_project = user_projects(:one)
  end

  test "visiting the index" do
    visit user_projects_url
    assert_selector "h1", text: "User Projects"
  end

  test "creating a User project" do
    visit user_projects_url
    click_on "New User Project"

    click_on "Create User project"

    assert_text "User project was successfully created"
    click_on "Back"
  end

  test "updating a User project" do
    visit user_projects_url
    click_on "Edit", match: :first

    click_on "Update User project"

    assert_text "User project was successfully updated"
    click_on "Back"
  end

  test "destroying a User project" do
    visit user_projects_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User project was successfully destroyed"
  end
end
