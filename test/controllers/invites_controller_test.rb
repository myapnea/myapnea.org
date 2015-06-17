require 'test_helper'

class InvitesControllerTest < ActionController::TestCase

  setup do
    @valid_user = users(:user_1)
  end

  test "should get new for logged in user" do
    login(@valid_user)
    get :new
    assert_response :success
  end

  test "should not get new for logged out user" do
    get :new
    assert_response :redirect
  end

end
