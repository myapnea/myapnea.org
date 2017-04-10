# frozen_string_literal: true

require 'test_helper'

# Test for publicly available pages.
class ExternalControllerTest < ActionController::TestCase
  setup do
    @regular_user = users(:user_1)
  end

  test 'should get contact' do
    get :contact
    assert_response :success
  end

  test 'should get community' do
    get :community
    assert_response :success
  end

  test 'should get voting' do
    get :voting
    assert_response :success
  end

  test 'should get landing' do
    get :landing
    assert_response :success
  end

  test 'should get landing for regular user' do
    login(@regular_user)
    get :landing
    assert_response :success
  end
end
