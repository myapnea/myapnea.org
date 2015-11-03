require 'test_helper'

class CoenrollmentControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_1)
    @heh_user = users(:heh_1)
  end

  test 'should get join health eheart as user' do
    login(@user)
    get :join_health_eheart
    assert_response :success
  end

  test 'should not get join health eheart as public viewer' do
    get :join_health_eheart
    assert_redirected_to new_user_session_path
  end

  test 'should get goto health eheart as user' do
    login(@user)
    get :goto_health_eheart
    @user.reload
    assert_redirected_to "https://www.health-eheartstudy.org/?rfk=#{ENV['heh_referral_key']}&id=#{@user.outgoing_heh_token}"
  end

  test 'should not get goto health eheart as public viewer' do
    get :goto_health_eheart
    assert_redirected_to new_user_session_path
  end

  test 'should get welcome health eheart users as user with token as parameter' do
    login(@user)
    get :welcome_health_eheart_members, incoming_heh_token: '14151515'
    assert_equal '14151515', session[:incoming_heh_token]
    assert_redirected_to link_health_eheart_member_path
  end

  test 'should get welcome health eheart users as public viewer with token as parameter' do
    get :welcome_health_eheart_members, incoming_heh_token: '14151515'
    assert_equal '14151515', session[:incoming_heh_token]
    assert_redirected_to welcome_health_eheart_members_path
  end

  test 'should get welcome health eheart members as user' do
    login(@user)
    get :welcome_health_eheart_members
    assert_redirected_to link_health_eheart_member_path
  end

  test 'should get welcome health eheart members as user and redirect with set token' do
    login(@user)
    session[:incoming_heh_token] = '14151515'
    get :welcome_health_eheart_members
    assert_redirected_to link_health_eheart_member_path
  end

  test 'should get welcome health eheart members as public viewer' do
    get :welcome_health_eheart_members
    assert_response :success
  end

  test 'should link health eheart member as user' do
    login(@user)
    get :link_health_eheart_member
    assert_redirected_to dashboard_path
  end

  test 'should link health eheart member as user with session token' do
    login(@user)
    session[:incoming_heh_token] = 'heh5050505'
    get :link_health_eheart_member
    @user.reload
    assert_equal 'heh5050505', @user.incoming_heh_token
    assert_not_nil @user.incoming_heh_at
    assert_redirected_to congratulations_health_eheart_members_path
  end

  test 'should not link health eheart member as public viewer' do
    get :link_health_eheart_member
    assert_redirected_to new_user_session_path
  end

  test 'should get congratulations health eheart members for user' do
    login(@user)
    get :congratulations_health_eheart_members
    assert_response :success
  end

  test 'should not get congratulations health eheart members for public viewer' do
    get :congratulations_health_eheart_members
    assert_redirected_to new_user_session_path
  end

  test 'should remove health eheart for user' do
    login(@heh_user)
    patch :remove_health_eheart
    @heh_user.reload
    assert_nil @heh_user.incoming_heh_token
    assert_not_nil @heh_user.incoming_heh_at
    assert_nil @heh_user.outgoing_heh_at
    assert_redirected_to account_path
  end

  test 'should not remove health eheart for public viewer' do
    patch :remove_health_eheart
    assert_redirected_to new_user_session_path
  end
end
