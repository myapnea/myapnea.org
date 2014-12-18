require 'test_helper.rb'

class StaticControllerTest < ActionController::TestCase

  test "should get about" do
    get :intro
    assert_response :success
  end

  test "should get landing when logged out" do
    get :home
    assert_template 'landing'
    assert_response :success
  end

  test "should get home page when logged in" do
    login(users(:user_1))
    get :home
    assert_template 'home'
    assert_response :success
  end

end
