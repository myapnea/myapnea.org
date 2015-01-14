require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase


  test "provider can see their profile page" do
    login(users(:provider_1))

    get :profile

    assert_response :success


  end

  test "normal user cannot see the provider profile page" do
    login(users(:user_1))

    get :profile

    assert_authorization_exception
  end


end
