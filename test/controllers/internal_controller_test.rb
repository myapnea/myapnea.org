# frozen_string_literal: true

require 'test_helper'

# Test to assure that interal pages load properly for users.
class InternalControllerTest < ActionDispatch::IntegrationTest
  def setup
    @regular_user = users(:user_1)
  end

  test 'should get dashboard' do
    sign_in_as(@regular_user, 'password')
    get dashboard_path
    assert_response :success
  end

  test 'should get settings' do
    sign_in_as(@regular_user, 'password')
    get dashboard_path
    assert_response :success
  end
end
