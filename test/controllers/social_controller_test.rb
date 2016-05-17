# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure that community page displays.
class SocialControllerTest < ActionController::TestCase
  test 'should show community page' do
    get :overview
    assert_response :success
  end

  test 'should show community page to logged in user' do
    login(users(:user_2))
    get :overview
    assert_response :success
  end
end
