# frozen_string_literal: true

require 'test_helper'

SimpleCov.command_name 'test:integration'

# Tests to assure that user navigation is working as intended.
class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @regular_user = users(:user_1)
    @deleted = users(:deleted)
  end

  test 'should get root path' do
    get '/'
    assert_equal '/', path
  end

  test 'should get sign up page' do
    get new_user_registration_path
    assert_equal new_user_registration_path, path
    assert_response :success
  end

  test 'should register new account' do
    post user_registration_path, params: {
      user: {
        first_name: 'register', last_name: 'account',
        email: 'register@account.com', password: 'registerpassword098765',
        emails_enabled: '1', over_eighteen: '1'
      }
    }
    assert_equal I18n.t('devise.registrations.signed_up'), flash[:notice]
    assert_redirected_to dashboard_path
  end

  test 'should login regular user' do
    get dashboard_path
    get new_user_session_path
    sign_in_as(@regular_user, 'password')
    assert_equal dashboard_path, path
  end

  test 'should not login deleted user' do
    get new_user_session_path
    sign_in_as(@deleted, 'password')
    assert_equal new_user_session_path, path
  end

  test 'should friendly forward after login' do
    get topics_path
    get new_user_session_path
    sign_in_as(@regular_user, 'password')
    assert_equal topics_path, path
  end

  test 'should friendly forward after logout' do
    get topics_path
    sign_in_as(@regular_user, 'password')
    get topics_path
    get destroy_user_session_path
    assert_redirected_to topics_path
  end

  test 'blog rss should not be stored in friendly forwarding after login' do
    get blog_path(format: 'atom')
    get new_user_session_path
    sign_in_as(@regular_user, 'password')
    assert_equal dashboard_path, path
  end
end
