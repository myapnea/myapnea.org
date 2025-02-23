# frozen_string_literal: true

require "test_helper"

SimpleCov.command_name "test:integration"

# Tests to assure that user navigation is working as intended.
class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @regular = users(:regular)
    @deleted = users(:deleted)
  end

  test "should get root path" do
    get "/"
    assert_equal "/", path
  end

  # test "should get sign up page" do
  #   get new_user_registration_url
  #   assert_equal new_user_registration_path, path
  #   assert_response :success
  # end

  # test "should register new account" do
  #   post user_registration_url, params: {
  #     user: {
  #       username: "registeraccount",
  #       email: "register@account.com",
  #       password: "registerpassword098765"
  #     }
  #   }
  #   assert_equal I18n.t("devise.registrations.signed_up_but_unconfirmed"), flash[:notice]
  #   assert_redirected_to root_url
  # end

  test "should login regular user" do
    get dashboard_url
    get new_user_session_url
    sign_in_as(@regular, "password")
    assert_equal dashboard_path, path
  end

  test "should not login deleted user" do
    get new_user_session_url
    sign_in_as(@deleted, "password")
    assert_equal new_user_session_path, path
  end

  test "should friendly forward after login" do
    get topics_url
    get new_user_session_url
    sign_in_as(@regular, "password")
    assert_equal topics_path, path
  end

  test "should friendly forward after logout" do
    get topics_url
    sign_in_as(@regular, "password")
    get topics_url
    get destroy_user_session_url
    assert_redirected_to topics_url
  end

  test "blog rss should not be stored in friendly forwarding after login" do
    get blog_url(format: "atom")
    get new_user_session_url
    sign_in_as(@regular, "password")
    assert_equal dashboard_path, path
  end
end
