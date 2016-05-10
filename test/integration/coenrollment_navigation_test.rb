# frozen_string_literal: true

require 'test_helper'

# Tests navigation and setting of coenrollment token across sign in and
# new user registration
class CoenrollmentNavigationTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @valid = users(:user_1)
  end

  test 'should friendly forward to join heh bridge consent after sign in' do
    get '/join-health-eheart'
    assert_redirected_to new_user_session_path

    sign_in_as @valid, 'password'
    assert_equal '/join-health-eheart', path
  end

  test 'should set heh incoming token from registration' do
    get '/welcome-health-eheart-members/heh12345'
    assert_equal 'heh12345', session[:incoming_heh_token]
    assert_redirected_to welcome_health_eheart_members_path

    post_via_redirect '/', user: { first_name: 'New User', last_name: 'New User', email: 'new@user.com', password: 'password', over_eighteen: '1' }
    assert_equal '/get-started', path

    get '/dashboard'
    assert_redirected_to link_health_eheart_member_path

    get '/link_health_eheart_member'
    assert_equal 'heh12345', User.find_by_email('new@user.com').incoming_heh_token
    assert_redirected_to congratulations_health_eheart_members_path
  end

  test 'should set heh incoming token from login' do
    get '/welcome-health-eheart-members/heh23456'
    assert_equal 'heh23456', session[:incoming_heh_token]
    assert_redirected_to welcome_health_eheart_members_path

    sign_in_as @valid, 'password'
    @valid.reload
    assert_equal 'heh23456', @valid.incoming_heh_token
    assert_equal '/congratulations-health-eheart-members', path
  end

  test 'should set heh incoming token for logged in user' do
    sign_in_as @valid, 'password'
    get '/welcome-health-eheart-members/heh34567'
    assert_equal 'heh34567', session[:incoming_heh_token]
    assert_redirected_to link_health_eheart_member_path

    get '/link_health_eheart_member'
    @valid.reload
    assert_equal 'heh34567', @valid.incoming_heh_token
    assert_redirected_to congratulations_health_eheart_members_path
  end
end
