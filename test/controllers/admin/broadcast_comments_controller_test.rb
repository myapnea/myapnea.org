# frozen_string_literal: true

require 'test_helper'

# Tests to assure that admins can review blog comments
class Admin::BroadcastCommentsControllerTest < ActionController::TestCase
  test 'should get index' do
    login(users(:owner))
    get :index
    assert_response :success
  end
end
