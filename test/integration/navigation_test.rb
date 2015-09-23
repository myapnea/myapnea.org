require 'test_helper'

SimpleCov.command_name 'test:integration'

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @valid = users(:user_1)
    @deleted = users(:deleted_user)
  end

  test 'should get root path' do
    get '/'
    assert_equal '/', path
  end

  test 'should get forums' do
    get '/forums'
    assert_equal '/forums', path
  end

  test 'should login regular user' do
    get '/dashboard'
    assert_equal '/dashboard', path

    sign_in_as @valid, 'password'
    assert_equal '/', path
    # assert_equal I18n.t('devise.sessions.signed_in'), flash[:notice]
  end

  test 'should not login deleted user' do
    get '/get-started'
    assert_redirected_to new_user_session_path

    sign_in_as @deleted, 'password'
    assert_equal new_user_session_path, path
    assert_equal I18n.t('devise.failure.inactive'), flash[:alert]
  end
end
