require 'test_helper'

class Api::V1::AccountControllerTest < ActionController::TestCase

  setup do
    @user = users(:user_2)
    @participant = users(:participant)
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "should get user types for logged in user" do
    login(@user)
    get :user_types, format: :json
    assert_response :success

    assert_equal json_response['adult_diagnosed'], true
    assert_equal json_response['caregiver_adult'], false
  end

  test "should not get user types for logged out user" do
    get :user_types, format: :json
    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  test "should set user type for logged in user" do
    login(@user)
    assert_difference('User.where(caregiver_adult: true).count') do
      post :set_user_types, user: {id: @user.id, caregiver_adult: true }, format: :json
    end

    assert_equal json_response['adult_diagnosed'], true
    assert_equal json_response['caregiver_adult'], true
  end

  test "should get ready for research" do
    login(@participant)
    get :ready_for_research, format: :json
    assert_response :success

    assert_equal json_response['ready_for_research'], true
  end

  test "should accept consent" do
    login(@user)
    assert_difference('User.where.not(accepted_consent_at: nil).count') do
      post :accept_consent, format: :json
    end

    assert_equal json_response['ready_for_research'], true
  end

  test "should process date of birth" do
    login(users(:api_user))
    post :set_dob, month: '01', day: '01', year: '1950', format: :json

    assert_equal '01/01/1950', assigns(:dob_answer).answer_values.first.text_value

    assert_equal true, json_response['success']
  end

  test "should process height and weight" do
    login(users(:api_user))
    post :set_height_weight, feet: '5', inches: '01', pounds: '500', format: :json

    assert_equal 500, assigns(:weight_answer).answer_values.first.numeric_value
    assert_equal 61, assigns(:height_answer).answer_values.first.numeric_value

    assert_equal true, json_response['success']
  end

end
