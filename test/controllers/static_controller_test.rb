# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure static pages are displayed to public users.
class StaticControllerTest < ActionController::TestCase
  test 'should get about' do
    get :about
    assert_response :success
  end

  test 'should get team' do
    get :team
    assert_response :success
  end

  test 'should get partners' do
    get :partners
    assert_response :success
  end
end
