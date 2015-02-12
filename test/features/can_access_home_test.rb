require "test_helper"
include Warden::Test::Helpers
Warden.test_mode!

feature "CanAccessHome" do

  def setup
    @user = users(:user_1)
  end

  scenario "logged out homepage loads" do
    visit root_path
    page.must_have_content "Wake up to a better future!"
    page.wont_have_content "Sign out"
  end

  scenario "user can log in" do
    visit new_user_session_path
    page.must_have_content "Not yet a Member?"

    fill_in 'Email',    with: @user.email, match: :prefer_exact
    fill_in 'Password', with: "password", match: :prefer_exact
    click_button 'Sign In'

    page.must_have_content "Sign out"
  end

  scenario "user can log out" do
    login_as(@user, scope: :user)
    visit research_topics_path
    page.must_have_content "you can cast up to"
    click_on 'Sign out'
    page.must_have_content "Login"
  end

end
