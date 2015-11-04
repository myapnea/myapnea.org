require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should get dashboard" do
    login(users(:social))
    get :dashboard
    assert_response :success
  end

  test "should get landing for logged out user" do
    get :dashboard
    assert_template 'home/landing'
    assert_response :success
  end

  test "should get landing for logged in user" do
    login(users(:social))
    get :landing
    assert_response :success
  end

  test "should get posts using ajax" do
    login(users(:social))
    post :posts, page: "2", format: "js"
    assert_not_nil assigns(:posts)
    assert_template :posts
    assert_response :success
  end

  test "should not get posts using ajax for logged out user" do
    post :posts, page: "2", format: "js"
    assert_nil assigns(:posts)
    assert_response :unauthorized
  end

end
