# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test 'should get dashboard' do
    login(users(:social))
    get :dashboard
    assert_response :success
  end

  test 'should get landing for logged out user' do
    get :dashboard
    assert_template 'external/landing'
    assert_response :success
  end
end
