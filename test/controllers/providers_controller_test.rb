require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @regular_user = users(:user_1)
    @provider = users(:provider)
  end

  test "should get index for logged out user" do
    get :index
    assert_not_nil assigns(:providers)
    assert_response :success
  end

  test "should get index for regular user" do
    login(@regular_user)
    get :index
    assert_not_nil assigns(:providers)
    assert_response :success
  end

  test "should get index for owner" do
    login(@owner)
    get :index
    assert_not_nil assigns(:providers)
    assert_response :success
  end

  test "should get index for provider" do
    login(@provider)
    get :index
    assert_not_nil assigns(:providers)
    assert_response :success
  end

  test "should show provider for logged out user" do
    get :show, id: @provider.slug
    assert_not_nil assigns(:provider)
    assert_response :success
  end

  test "should show provider for valid user" do
    login(@regular_user)
    get :show, id: @provider.slug
    assert_not_nil assigns(:provider)
    assert_response :success
  end

  test "should show provider for owner" do
    login(@owner)
    get :show, id: @provider.slug
    assert_not_nil assigns(:provider)
    assert_response :success
  end

  test "should show provider for provider" do
    login(@provider)
    get :show, id: @provider.slug
    assert_not_nil assigns(:provider)
    assert_response :success
  end

end
