require 'test_helper.rb'

class SocialControllerTest < ActionController::TestCase
  test "Not logged in and Logged-in User can access the social overview page" do
    get :overview

    assert_response :success

    login(users(:user_2))

    get :overview

    assert_response :success


  end
end
