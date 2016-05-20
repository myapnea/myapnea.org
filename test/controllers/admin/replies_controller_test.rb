# frozen_string_literal: true

require 'test_helper'

# Tests to assure that admins can review forum replies
class Admin::RepliesControllerTest < ActionController::TestCase
  test 'should get index' do
    login(users(:owner))
    get :index
    assert_response :success
  end
end
