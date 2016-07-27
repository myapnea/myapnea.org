# frozen_string_literal: true

require 'test_helper'

class EngagementResponsesControllerTest < ActionController::TestCase
  setup do
    @engagement_response = engagement_responses(:one)
    @engagement = engagements(:one)
    @diagnosed = users(:adult_diagnosed)
  end

  test 'should create engagement_response' do
    login(@diagnosed)
    assert_difference('EngagementResponse.count') do
      post :create, params: {
        engagement_id: @engagement, engagement_response: { response: 'This is my response' }
      }, format: 'js'
    end
    assert_response :success
  end

  test 'should destroy engagement_response' do
    assert_no_difference('EngagementResponse.current.count') do
      delete :destroy, params: { engagement_id: @engagement, id: @engagement_response }
    end

    login(users(:owner))
    assert_difference('EngagementResponse.current.count', -1) do
      delete :destroy, params: { engagement_id: @engagement, id: @engagement_response }
    end
    assert_redirected_to engagement_path
  end
end
