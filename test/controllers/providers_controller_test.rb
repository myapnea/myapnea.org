require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @regular_user = users(:user_1)
    @provider = users(:provider_1)
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


  # test "provider can see their profile page" do
  #   assert users(:provider_1).can?(:act_as_provider)
  #   login(users(:provider_1))

  #   get :profile

  #   assert_response :success


  # end

  # test "normal user cannot see the provider profile page" do
  #   login(users(:user_1))

  #   get :profile

  #   assert_authorization_exception
  # end


  # test "provider can update their profile" do
  #   login(users(:provider_1))
  #   profile_params = {provider: {welcome_message: "New Message", photo: fixture_file_upload('../../test/support/rails.png'), provider_name: "New Name"}}

  #   post :update, profile_params

  #   assert_not_nil assigns(:provider)

  #   users(:provider_1).reload

  #   assert_equal File.join(CarrierWave::Uploader::Base.root.call, 'uploads', 'provider', 'photo', assigns(:provider).id.to_s, 'rails.png'), assigns(:provider).photo.path

  #   assert_equal profile_params[:provider][:welcome_message], users(:provider_1).welcome_message
  #   assert_equal profile_params[:provider][:provider_name], users(:provider_1).provider_name
  # end

end
