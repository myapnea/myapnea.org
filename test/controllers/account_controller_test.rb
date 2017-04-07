# frozen_string_literal: true

require 'test_helper.rb'

class AccountControllerTest < ActionController::TestCase
  setup do
    @regular_user = users(:user_1)
    @participant = users(:participant)
  end

  test 'should get registration user_type page for logged in user' do
    login(users(:user_1))
    get :get_started
    assert_response :success
  end

  test 'should get registration consent for logged in user' do
    login(users(:user_1))
    get :get_started_step_two
    assert_response :success
  end

  test 'should get user_type page for logged in user' do
    login(users(:user_1))
    get :user_type
    assert_response :success
  end

  test 'should set user_type page for logged in user and redirect to get started' do
    login(users(:user_1))
    post :set_user_type, params: { user: { researcher: '1' }, registration_process: '1' }
    assert_redirected_to get_started_step_two_path
  end

  test 'should change user_type page for logged in user and redirect to account' do
    login(users(:user_1))
    post :set_user_type, params: { user: { researcher: '1' } }
    assert_redirected_to account_path
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

  test 'should get privacy policy' do
    get :privacy_policy
    assert_response :success
  end

  test 'should get consent' do
    get :consent
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

  test 'should get terms and conditions for logged out user' do
    get :terms_and_conditions
    assert_response :success
  end

  test 'should get terms and conditions for regular user' do
    login(@regular_user)
    get :terms_and_conditions
    assert_response :success
  end

  test 'should get terms of access for logged out user' do
    get :terms_of_access
    assert_response :success
  end

  # TODO add test for terms of access accept/refute, add test for registration path

  test 'should mark consent and then privacy policy as read for user' do
    login(@regular_user)
    refute @regular_user.ready_for_research?
    get :consent
    assert_response :success
    assert_template 'consent'
    post :accepts_consent
    refute @regular_user.reload.ready_for_research?
    get :privacy_policy
    assert_response :success
    assert_template 'privacy_policy'
    post :accepts_privacy
    assert @regular_user.reload.ready_for_research?
    assert_redirected_to surveys_path
  end

  test 'should mark privacy and then consent as read for user' do
    login(@regular_user)
    get :privacy_policy
    assert_response :success
    assert_template 'privacy_policy'
    post :accepts_privacy
    refute @regular_user.reload.ready_for_research?
    get :consent
    assert_response :success
    assert_template 'consent'
    post :accepts_consent
    assert @regular_user.reload.ready_for_research?
    assert_redirected_to surveys_path
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

  # Deprecated in use, can be removed
  test 'should accept privacy during get-started for new user' do
    login(@regular_user)
    assert_nil @regular_user.accepted_privacy_policy_at
    post :accepts_privacy, params: { get_started: true }
    @regular_user.reload
    assert_not_nil @regular_user.accepted_privacy_policy_at
    assert_redirected_to consent_path
  end
  # end deprecated

  test 'should accept consent during get started for new user and redirect to step three' do
    login(@regular_user)
    assert_nil @regular_user.accepted_privacy_policy_at
    assert_nil @regular_user.accepted_consent_at
    post :accepts_consent, params: { get_started: true }
    @regular_user.reload
    assert_not_nil @regular_user.accepted_consent_at
    assert_redirected_to get_started_step_three_path
  end

  test 'should retrieve about me survey for nonacademic user' do
    login(@participant)
    get :get_started_step_three
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
  end

  test 'should accept terms of access' do
    login(@regular_user)
    assert_nil @regular_user.accepted_terms_of_access_at
    post :accepts_terms_of_access
    @regular_user.reload
    assert_not_nil @regular_user.accepted_terms_of_access_at
  end

  test 'should accept terms of access during registration' do
    login(@regular_user)
    assert_nil @regular_user.accepted_terms_of_access_at
    post :accepts_terms_of_access, params: { get_started: true }
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

  # User type creation and Survey assignment
  test 'should assign correct surveys for adult_diagnosed role' do
    login(users(:blank_slate))
    patch :set_user_type, params: { user: { adult_diagnosed: true } }
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-me')
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-my-family')
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-quality')
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-apnea')
  end

  test 'should assign correct surveys for adult_at_risk role' do
    login(users(:blank_slate))
    patch :set_user_type, params: { user: { adult_at_risk: true } }
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-me')
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-my-family')
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-quality')
    refute_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-apnea')
  end

  test 'should assign correct surveys for caregiver_adult role' do
    login(users(:blank_slate))
    patch :set_user_type, params: { user: { caregiver_adult: true } }
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-me')
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-my-family')
    refute_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-quality')
    refute_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-apnea')
  end

  test 'should assign correct surveys for caregiver_child role' do
    login(users(:blank_slate))
    patch :set_user_type, params: { user: { caregiver_child: true } }
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-me')
    assert_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('about-my-family')
    refute_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-quality')
    refute_includes users(:blank_slate).answer_sessions.collect(&:survey), Survey.find_by_slug('my-sleep-apnea')
  end

  test 'should not assign any surveys for researcher' do
    login(users(:blank_slate))
    patch :set_user_type, params: { user: { researcher: true } }
    assert_empty users(:blank_slate).answer_sessions
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
