require 'test_helper.rb'

class StaticControllerTest < ActionController::TestCase

  test "should get about" do
    get :intro
    assert_response :success
  end

  test "should get landing" do
    get :landing
    assert_response :success
  end

  test "should get landing and redirect to home page for logged in user" do
    login(users(:user_1))
    get :landing
    assert_redirected_to root_path
  end

end
