# frozen_string_literal: true

require 'test_helper'

# Test for publicly available pages
class ExternalControllerTest < ActionController::TestCase
  test 'should get contact' do
    get :contact
    assert_response :success
  end

  test 'should get voting' do
    get :voting
    assert_response :success
  end
end
