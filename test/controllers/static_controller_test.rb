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

end
