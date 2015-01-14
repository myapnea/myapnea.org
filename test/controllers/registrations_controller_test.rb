require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase


  test "a new user should be able to sign up" do
    request.env["devise.mapping"] = Devise.mappings[:user]

    assert_difference('User.count') do
      post :create, user: { first_name: 'First Name', last_name: 'Last Name', year_of_birth: '1980', zip_code: '12345', email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:user)
    assert_equal 'First Name', assigns(:user).first_name
    assert_equal 'Last Name', assigns(:user).last_name
    assert_equal 1980, assigns(:user).year_of_birth
    assert_equal '12345', assigns(:user).zip_code
    assert_equal 'new_user@example.com', assigns(:user).email

    assert_redirected_to home_path
  end

  test "a new user should not be able to sign up without required fields" do
    request.env["devise.mapping"] = Devise.mappings[:user]

    assert_difference('User.count', 0) do
      post :create, user: { first_name: '', last_name: '', year_of_birth: '', zip_code: '', email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:user)

    assert assigns(:user).errors.size > 0
    assert_equal ["can't be blank"], assigns(:user).errors[:first_name]
    assert_equal ["can't be blank"], assigns(:user).errors[:last_name]
    assert_equal ["can't be blank", "is not a number"], assigns(:user).errors[:year_of_birth]

    assert_template 'devise/registrations/new'
    assert_response :success
  end

  test "a new user needs to meet the age requirements" do
    request.env["devise.mapping"] = Devise.mappings[:user]

    assert_difference('User.count', 0) do
      post :create, user: { first_name: 'First Name', last_name: 'Last Name', year_of_birth: "#{Date.today.year - 17}", zip_code: '12345', email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:user)

    assert assigns(:user).errors.size > 0
    assert_equal ["must be less than or equal to #{Date.today.year - 18}"], assigns(:user).errors[:year_of_birth]

    assert_template 'devise/registrations/new'
    assert_response :success
  end

  test "a new user needs to be born after 1900" do
    request.env["devise.mapping"] = Devise.mappings[:user]

    assert_difference('User.count', 0) do
      post :create, user: { first_name: 'First Name', last_name: 'Last Name', year_of_birth: "1899", zip_code: '12345', email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:user)

    assert assigns(:user).errors.size > 0
    assert_equal ["must be greater than or equal to 1900"], assigns(:user).errors[:year_of_birth]

    assert_template 'devise/registrations/new'
    assert_response :success
  end

  test "a user can sign up with a custom provider" do
    request.env["devise.mapping"] = Devise.mappings[:user]

    assert_difference('User.count') do
      post :create, user: { first_name: 'First Name', last_name: 'Last Name', year_of_birth: '1980', zip_code: '12345', email: 'new_user@example.com', password: 'password', password_confirmation: 'password', provider_name: 'Custom Name' }
    end

    assert_not_nil assigns(:user)
    assert_equal "Custom Name", assigns(:user).provider_name
    assert_redirected_to home_path

  end

  test "a user can sign up with an existing provider" do
    request.env["devise.mapping"] = Devise.mappings[:user]

    assert_difference('User.count') do
      post :create, user: { first_name: 'First Name', last_name: 'Last Name', year_of_birth: '1980', zip_code: '12345', email: 'new_user@example.com', password: 'password', password_confirmation: 'password', provider_id: users(:provider_1).id }

    end


    assert_not_nil assigns(:user)
    assert_equal users(:provider_1), assigns(:user).provider
    assert_redirected_to home_path

  end

  test "a new provider should be able to sign up" do
    request.env["devise.mapping"] = Devise.mappings[:provider]

    assert_difference('User.count') do
      post :create, provider: { first_name: 'First Name', last_name: 'Last Name', provider_name: "Health Associates", slug: "health-associates", email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:provider)
    assert_equal 'First Name', assigns(:provider).first_name
    assert_equal 'Last Name', assigns(:provider).last_name
    assert_equal "Health Associates", assigns(:provider).provider_name
    assert_equal 'health-associates', assigns(:provider).slug
    assert_equal 'new_user@example.com', assigns(:provider).email

    assert_redirected_to provider_profile_path

  end

  test "an invalid provider should should not be able to sign up" do
    request.env["devise.mapping"] = Devise.mappings[:provider]

    assert_difference('User.count', 0) do
      post :create, provider: { first_name: '', last_name: '', provider_name: "", slug: "", zip_code: '', email: 'new_user@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:provider)

    assert assigns(:provider).errors.size > 0
    assert_equal ["can't be blank"], assigns(:provider).errors[:first_name]
    assert_equal ["can't be blank"], assigns(:provider).errors[:last_name]
    assert_equal ["can't be blank"], assigns(:provider).errors[:slug]
    assert_equal ["can't be blank"], assigns(:provider).errors[:provider_name]


    assert_template 'myapnea/static/beta/_providers'
    assert_response :success
  end

end
