# frozen_string_literal: true

require 'test_helper'

# Tests to assure admins can manage users.
class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_2)
    @admin = users(:admin)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  def user_params
    {
      first_name: 'FirstName',
      last_name: 'LastName',
      email: 'valid_updated_email@example.com',
      emails_enabled: '1'
    }
  end

  test 'should export users as admin' do
    login(@admin)
    get :export, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  test 'should not export users as moderator' do
    login(@moderator)
    get :export, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_redirected_to root_path
  end

  test 'should not export users as regular user' do
    login(@regular_user)
    get :export, format: 'csv'
    assert_nil assigns(:csv_string)
  end

  test 'should not export users for logged out user' do
    get :export, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_response :unauthorized
  end

  test 'should get index for admin' do
    login(@admin)
    get :index
    assert_not_nil assigns(:users)
    assert_response :success
  end

  test 'should not get index for regular user' do
    login(@regular_user)
    get :index
    assert_nil assigns(:users)
    assert_equal 'You do not have sufficient privileges to access that page.', flash[:alert]
    assert_redirected_to root_path
  end

  test 'should not get index for logged out user' do
    get :index
    assert_nil assigns(:users)
    assert_redirected_to new_user_session_path
  end

  test 'should show user for admin' do
    login(@admin)
    get :show, params: { id: @user }
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test 'should not show user for regular user' do
    login(@regular_user)
    get :show, params: { id: @user }
    assert_nil assigns(:user)
    assert_equal 'You do not have sufficient privileges to access that page.', flash[:alert]
    assert_redirected_to root_path
  end

  test 'should not show user for public user' do
    get :show, params: { id: @user }
    assert_nil assigns(:user)
    assert_redirected_to new_user_session_path
  end

  test 'should get edit for admin' do
    login(@admin)
    get :edit, params: { id: @user }
    assert_response :success
  end

  test 'should not edit user for regular user' do
    login(@regular_user)
    get :edit, params: { id: @user }
    assert_nil assigns(:user)
    assert_equal 'You do not have sufficient privileges to access that page.', flash[:alert]
    assert_redirected_to root_path
  end

  test 'should not edit user for logout out user' do
    get :edit, params: { id: @user }
    assert_nil assigns(:user)
    assert_redirected_to new_user_session_path
  end

  test 'should update user for admin' do
    login(@admin)
    put :update, params: { id: @user, user: user_params }

    assert_not_nil assigns(:user)
    assert_equal true, assigns(:user).emails_enabled?

    assert_redirected_to user_path(assigns(:user))
  end

  test 'should update user and enable survey building for user as admin' do
    login(@admin)
    put :update, params: { id: @user, user: { can_build_surveys: '1' } }
    assert_not_nil assigns(:user)
    assert_equal true, assigns(:user).can_build_surveys?
    assert_redirected_to user_path(assigns(:user))
  end

  test 'should not update user and enable survey building for user as regular user' do
    login(@regular_user)
    put :update, params: { id: @user, user: { can_build_surveys: '1' } }
    assert_nil assigns(:user)
    assert_equal false, @user.can_build_surveys?
    assert_redirected_to root_path
  end

  test 'should not update user for regular user' do
    login(@regular_user)
    put :update, params: { id: @user, user: user_params }
    assert_equal 'You do not have sufficient privileges to access that page.', flash[:alert]
    assert_redirected_to root_path
  end

  test 'should not update user for logged out user' do
    put :update, params: { id: @user, user: user_params }
    assert_redirected_to new_user_session_path
  end

  test 'should not update user with blank name' do
    login(@admin)
    put :update, params: { id: @user, user: { first_name: '', last_name: '' } }
    assert_not_nil assigns(:user)
    assert_template 'edit'
  end

  test 'should not update user with invalid id' do
    login(@admin)
    put :update, params: { id: -1, user: user_params }
    assert_nil assigns(:user)
    assert_redirected_to users_path
  end

  test 'should destroy user for admin' do
    login(@admin)
    assert_difference('User.current.count', -1) do
      delete :destroy, params: { id: @user }
    end
    assert_redirected_to users_path
  end

  test 'should destroy user for admin with ajax' do
    login(@admin)
    assert_difference('User.current.count', -1) do
      delete :destroy, params: { id: @user }, format: 'js'
    end
    assert_template 'destroy'
    assert_response :success
  end

  test 'should not destroy user for regular user' do
    login(@regular_user)
    assert_difference('User.current.count', 0) do
      delete :destroy, params: { id: @user }
    end
    assert_equal 'You do not have sufficient privileges to access that page.', flash[:alert]
    assert_redirected_to root_path
  end

  test 'should not destroy user for admin' do
    assert_difference('User.current.count', 0) do
      delete :destroy, params: { id: @user }
    end
    assert_redirected_to new_user_session_path
  end
end
