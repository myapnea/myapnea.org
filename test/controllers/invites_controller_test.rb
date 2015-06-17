require 'test_helper'

class InvitesControllerTest < ActionController::TestCase

  setup do
    @valid_user = users(:user_1)
  end

  test "should get members for logged in user" do
    login(@valid_user)
    get :members
    assert_response :success
  end

  test "should not get members for logged out user" do
    get :members
    assert_response :redirect
  end

  test "should get providers for logged in user" do
    login(@valid_user)
    get :providers
    assert_response :success
  end

  test "should not get providers for logged out user" do
    get :providers
    assert_response :redirect
  end

end
