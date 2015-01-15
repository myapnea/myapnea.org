require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase


  test "provider can see their profile page" do
    assert users(:provider_1).can?(:act_as_provider)
    login(users(:provider_1))

    get :profile

    assert_response :success


  end

  test "normal user cannot see the provider profile page" do
    login(users(:user_1))

    get :profile

    assert_authorization_exception
  end


  test "provider can update their profile" do
    login(users(:provider_1))
    profile_params = {provider: {welcome_message: "New Message", photo: fixture_file_upload('../../test/support/rails.png'), provider_name: "New Name"}}

    post :update, profile_params

    assert_not_nil assigns(:provider)

    users(:provider_1).reload

    assert_equal File.join(CarrierWave::Uploader::Base.root.call, 'uploads', 'provider', 'photo', assigns(:provider).id.to_s, 'rails.png'), assigns(:provider).photo.path

    assert_equal profile_params[:provider][:welcome_message], users(:provider_1).welcome_message
    assert_equal profile_params[:provider][:provider_name], users(:provider_1).provider_name
  end

end
