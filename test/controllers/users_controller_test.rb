require "test_helper"

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:user_2)
  end

  test "should export users as owner" do
    login(users(:owner))
    get :export, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  test "should not export users as moderator" do
    login(users(:moderator_1))
    get :export, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_redirected_to root_path
  end

  test "should not export users as regular user" do
    login(users(:user_1))
    get :export, format: 'csv'
    assert_nil assigns(:csv_string)
  end

  test "should not export users for logged out user" do
    get :export, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_response :unauthorized
  end

  test "should get index for owner" do
    login(users(:owner))
    get :index
    assert_not_nil assigns(:users)
    assert_response :success
  end

  test "should not get index for regular user" do
    login(users(:user_1))
    get :index
    assert_nil assigns(:users)
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_path
  end

  test "should not get index for logged out user" do
    get :index
    assert_nil assigns(:users)
    assert_redirected_to new_user_session_path
  end

  test "should show user for owner" do
    login(users(:owner))
    get :show, id: @user
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test "should not show user for regular user" do
    login(users(:user_1))
    get :show, id: @user
    assert_nil assigns(:user)
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_path
  end

  test "should not show user for loggout out user" do
    get :show, id: @user
    assert_nil assigns(:user)
    assert_redirected_to new_user_session_path
  end

  test "should get edit for owner" do
    login(users(:owner))
    get :edit, id: @user
    assert_response :success
  end

  test "should not edit user for regular user" do
    login(users(:user_1))
    get :edit, id: @user
    assert_nil assigns(:user)
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_path
  end

  test "should not edit user for logout out user" do
    get :edit, id: @user
    assert_nil assigns(:user)
    assert_redirected_to new_user_session_path
  end

  test "should update user for owner" do
    login(users(:owner))
    put :update, id: @user, user: { first_name: 'FirstName', last_name: 'LastName', email: 'valid_updated_email@example.com' }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should not update user for regular user" do
    login(users(:user_1))
    put :update, id: @user, user: { first_name: 'FirstName', last_name: 'LastName', email: 'valid_updated_email@example.com' }
    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_path
  end

  test "should not update user for logged out user" do
    put :update, id: @user, user: { first_name: 'FirstName', last_name: 'LastName', email: 'valid_updated_email@example.com' }
    assert_redirected_to new_user_session_path
  end

  test "should not update user with blank name" do
    login(users(:owner))
    put :update, id: @user, user: { first_name: '', last_name: '' }
    assert_not_nil assigns(:user)
    assert_template 'edit'
  end

  test "should not update user with invalid id" do
    login(users(:owner))
    put :update, id: -1, user: { first_name: 'FirstName', last_name: 'LastName', email: 'valid_updated_email@example.com' }
    assert_nil assigns(:user)
    assert_redirected_to users_path
  end

  test "should destroy user for owner" do
    login(users(:owner))
    assert_difference('User.current.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test "should not destroy user for regular user" do
    login(users(:user_1))
    assert_difference('User.current.count', 0) do
      delete :destroy, id: @user
    end

    assert_equal "You do not have sufficient privileges to access that page.", flash[:alert]
    assert_redirected_to root_path
  end

  test "should not destroy user for owner" do
    assert_difference('User.current.count', 0) do
      delete :destroy, id: @user
    end

    assert_redirected_to new_user_session_path
  end

end
