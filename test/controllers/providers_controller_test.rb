require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase

  setup do
    request.env["devise.mapping"] = Devise.mappings[:provider]
  end

  test "a new provider should be able to sign up" do
    assert_difference('User.count') do
      post :create, provider: { first_name: 'First Name', last_name: 'Last Name', provider_name: "Health Associates", slug: "health-associates", email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:provider)
    assert_equal 'First Name', assigns(:provider).first_name
    assert_equal 'Last Name', assigns(:provider).last_name
    assert_equal "Health Associates", assigns(:provider).provider_name
    assert_equal 'health-associates', assigns(:provider).slug
    assert_equal 'new_user@example.com', assigns(:provider).email

    assert_redirected_to home_path
  end

  test "an invalid provider should should not be able to sign up" do

    assert_difference('User.count', 0) do
      post :create, provider: { first_name: '', last_name: '', provider_name: "", slug: "", zip_code: '', email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:provider)

    assert assigns(:provider).errors.size > 0
    assert_equal ["can't be blank"], assigns(:provider).errors[:first_name]
    assert_equal ["can't be blank"], assigns(:provider).errors[:last_name]
    assert_equal ["can't be blank"], assigns(:provider).errors[:slug]
    assert_equal ["can't be blank"], assigns(:provider).errors[:provider_name]


    assert_template 'providers/new'
    assert_response :success
  end


end
