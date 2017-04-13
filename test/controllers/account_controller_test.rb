# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure account settings can be updated.
class AccountControllerTest < ActionController::TestCase
  setup do
    @regular_user = users(:user_1)
    @participant = users(:participant)
  end

  test 'should get account for regular user' do
    login(@regular_user)
    get :account
    assert_response :success
  end

  test 'should suggest forum name for regular user' do
    login(@regular_user)
    get :suggest_random_forum_name, xhr: true, format: 'js'
    assert_not_nil assigns(:new_forum_name)
    assert_response :success
  end

  test 'should revoke consent for research participant' do
    assert_not_nil @participant.accepted_consent_at
    assert_not_nil @participant.accepted_privacy_policy_at
    login(@participant)
    post :revoke_consent
    @participant.reload
    assert_nil @participant.accepted_consent_at
    assert_nil @participant.accepted_privacy_policy_at
    assert_not_nil flash[:notice]
    assert_redirected_to root_path
  end

  test 'should not revoke consent for logged out user' do
    post :revoke_consent
    assert_redirected_to new_user_session_path
  end

  test 'should mark privacy policy as read and go to consent for user if consent is not read' do
    login(@regular_user)
    post :accepts_privacy
    @regular_user.reload
    assert_not_nil @regular_user.accepted_privacy_policy_at
    assert_redirected_to consent_path
  end

  test 'should mark consent as read and go to privacy policy for user if privacy policy has not been read' do
    login(@regular_user)
    post :accepts_consent
    @regular_user.reload
    assert_not_nil @regular_user.accepted_consent_at
    assert_redirected_to privacy_path
  end

  test 'should accept terms of access' do
    login(@regular_user)
    assert_nil @regular_user.accepted_terms_of_access_at
    post :accepts_terms_of_access
    @regular_user.reload
    assert_not_nil @regular_user.accepted_terms_of_access_at
  end

  test 'should accept update as nonacademic user' do
    login(@participant)
    assert_not_nil @participant.accepted_consent_at
    post :accepts_update
    @participant.reload
    assert_not_nil @participant.accepted_consent_at
  end

  test 'should update account information for user' do
    login(users(:social))
    new_last = 'Boylston'
    new_first = 'Jimmy'
    new_email = 'new_email@new.com'
    new_forum_name = 'NewForumName'
    refute_equal new_last, users(:social).last_name
    refute_equal new_first, users(:social).first_name
    refute_equal new_email, users(:social).email
    refute_equal new_forum_name, users(:social).forum_name
    patch :update, params: { user: { first_name: new_first, last_name: new_last, email: new_email, forum_name: new_forum_name } }
    users(:social).reload
    assert_equal new_last, users(:social).last_name
    assert_equal new_first, users(:social).first_name
    assert_equal new_email, users(:social).email
    assert_equal new_forum_name, users(:social).forum_name
  end

  test 'should not allow user to enter blank forum name' do
    login(users(:social))
    patch :update, params: { user: { forum_name: '' } }
    users(:social).reload
    assert_equal 'TomHaverford', users(:social).forum_name
    assert_response :success
  end

  test 'should not allow user to enter forum name as existing name with different casing' do
    login(users(:social))
    patch :update, params: { user: { forum_name: 'PARTICIPANT' } }
    users(:social).reload
    assert_equal 'TomHaverford', users(:social).forum_name
    assert_response :success
  end

  test 'should not update account for regular user with invalid user information' do
    login(@regular_user)
    patch :update, params: { user: { email: '' } }
    assert_template 'account'
    assert_response :success
  end

  test 'should change password for regular user' do
    login(@regular_user)
    patch :change_password, params: { user: { current_password: 'password', password: 'newpassword' } }
    assert_equal 'Your password has been changed.', flash[:notice]
    assert_redirected_to account_path
  end

  test 'should not change password for regular user with invalid current password' do
    login(@regular_user)
    patch :change_password, params: { user: { current_password: 'invalid', password: 'newpassword' } }
    assert_template 'account'
    assert_response :success
  end

  test 'should be delete account as regular user' do
    login(@regular_user)
    assert_difference('User.current.count', -1) do
      delete :destroy
    end
    assert_redirected_to landing_path
  end

  test 'should not delete account as public user' do
    assert_difference('User.current.count', 0) do
      delete :destroy
    end
    assert_redirected_to new_user_session_path
  end
end
