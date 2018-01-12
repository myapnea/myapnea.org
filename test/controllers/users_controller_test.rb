# frozen_string_literal: true

require "test_helper"

SimpleCov.command_name "test:controllers"

# Tests to assure admins can manage users.
class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_2)
    @admin = users(:admin)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  def user_params
    {
      full_name: "FirstName LastName",
      email: "valid_updated_email@example.com",
      emails_enabled: "1"
    }
  end

  test "should export users as admin" do
    login(@admin)
    get export_users_url(format: "csv")
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  test "should not export users as moderator" do
    login(@moderator)
    get export_users_url(format: "csv")
    assert_nil assigns(:csv_string)
    assert_redirected_to root_url
  end

  test "should not export users as regular user" do
    login(@regular_user)
    get export_users_url(format: "csv")
    assert_nil assigns(:csv_string)
  end

  test "should not export users for public user" do
    get export_users_url(format: "csv")
    assert_response :unauthorized
  end

  test "should get index for admin" do
    login(@admin)
    get users_url
    assert_not_nil assigns(:users)
    assert_response :success
  end

  test "should not get index for regular user" do
    login(@regular_user)
    get users_url
    assert_nil assigns(:users)
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_url
  end

  test "should not get index for public user" do
    get users_url
    assert_redirected_to new_user_session_url
  end

  test "should show user for admin" do
    login(@admin)
    get user_url(@user)
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test "should not show user for regular user" do
    login(@regular_user)
    get user_url(@user)
    assert_nil assigns(:user)
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_url
  end

  test "should not show user for public user" do
    get user_url(@user)
    assert_redirected_to new_user_session_url
  end

  test "should get edit for admin" do
    login(@admin)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should not edit user for regular user" do
    login(@regular_user)
    get edit_user_url(@user)
    assert_nil assigns(:user)
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_url
  end

  test "should not edit user for public user" do
    get edit_user_url(@user)
    assert_redirected_to new_user_session_url
  end

  test "should update user for admin" do
    login(@admin)
    patch user_url(@user), params: { user: user_params }
    assert_not_nil assigns(:user)
    assert_equal true, assigns(:user).emails_enabled?
    assert_redirected_to user_url(assigns(:user))
  end

  test "should update user and enable survey building for user as admin" do
    login(@admin)
    patch user_url(@user), params: { user: { can_build_surveys: "1" } }
    assert_not_nil assigns(:user)
    assert_equal true, assigns(:user).can_build_surveys?
    assert_redirected_to user_url(assigns(:user))
  end

  test "should not update user and enable survey building for user as regular user" do
    login(@regular_user)
    patch user_url(@user), params: { user: { can_build_surveys: "1" } }
    assert_nil assigns(:user)
    assert_equal false, @user.can_build_surveys?
    assert_redirected_to root_url
  end

  test "should not update user for regular user" do
    login(@regular_user)
    patch user_url(@user), params: { user: user_params }
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_url
  end

  test "should not update user for public user" do
    patch user_url(@user), params: { user: user_params }
    assert_redirected_to new_user_session_url
  end

  test "should not update user with blank name" do
    login(@admin)
    patch user_url(@user), params: { user: { full_name: "" } }
    assert_not_nil assigns(:user)
    assert_template "edit"
  end

  test "should not update user with invalid id" do
    login(@admin)
    patch user_url(-1), params: { user: user_params }
    assert_nil assigns(:user)
    assert_redirected_to users_url
  end

  test "should destroy user for admin" do
    login(@admin)
    assert_difference("User.current.count", -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
  end

  test "should destroy user for admin with ajax" do
    login(@admin)
    assert_difference("User.current.count", -1) do
      delete user_url(@user, format: "js")
    end
    assert_template "destroy"
    assert_response :success
  end

  test "should not destroy user for regular user" do
    login(@regular_user)
    assert_difference("User.current.count", 0) do
      delete user_url(@user)
    end
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_url
  end

  test "should not destroy user for admin" do
    assert_difference("User.current.count", 0) do
      delete user_url(@user)
    end
    assert_redirected_to new_user_session_url
  end
end
