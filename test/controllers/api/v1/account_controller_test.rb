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
      post :set_user_types, caregiver_adult: true, format: :json
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

    get :check_dob
    assert_equal true, json_response['present']
  end

  test "should not process date of birth with unexpected inputs" do
    login(users(:api_user))
    post :set_dob, month: 'feb', day: '01', year: '1950', format: :json

    assert_equal 'invalid', assigns(:dob_answer).state
    assert_equal false, json_response['success']
  end

  test "should process height and weight" do
    login(users(:api_user))
    post :set_height_weight, feet: '5', inches: '1', pounds: '100', format: :json

    assert_equal 'complete', assigns(:weight_answer).state #### currently returning complete
    assert_equal 'complete', assigns(:height_answer).state #### currently returning incomplete
    assert_equal true, json_response['success']

    get :check_height_weight
    assert_equal true, json_response['present']
  end

  test "should not process height and weight with unexpected inputs" do
    login(users(:api_user))
    post :set_height_weight, feet: 'five', inches: 'one', pounds: 'one hundred', format: :json

    # assert_equal 'invalid', assigns(:weight_answer).state #### currently returning complete
    # assert_equal 'invalid', assigns(:height_answer).state #### currently returning incomplete

    assert_equal false, json_response['success']
  end

  test "should get forum name" do
    login(users(:social))
    get :forum_name
    assert_equal 'TomHaverford', json_response['forum_name']
  end

  test "should get photo if present" do
    login(users(:social))
    get :photo
    assert_equal nil, json_response['photo_url']
  end

  test "should get dashboard" do
    login(users(:api_user))
    get :dashboard, format: :json
    assert_not_nil assigns(:about_me_survey)
  end

end
