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

end
