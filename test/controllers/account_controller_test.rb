require 'test_helper.rb'

class AccountControllerTest < ActionController::TestCase

  setup do
    @regular_user = users(:user_1)
    @participant = users(:participant)
  end


  test "should get registration user_type page for logged in user" do
    login(users(:user_1))
    get :get_started
    assert_response :success
  end

  test "should get registration provider profile page for logged in provider" do
    login(users(:provider_1))
    get :get_started_provider_profile
    assert_response :success
  end

  test "should get registration privacy page for logged in user" do
    login(users(:user_1))
    get :get_started_privacy
    assert_response :success
  end

  test "should get registration consent for logged in user" do
    login(users(:user_1))
    get :get_started_consent
    assert_response :success
  end

  test "should get registration about-me survey for logged in user" do
    Survey.load_from_file("about-me")
    login(users(:social))
    get :get_started_about_me
    assert_response :success
  end




  test "should get account for regular user" do
    login(@regular_user)
    get :account

    assert_response :success
  end

  test "should get privacy policy" do
    get :privacy_policy
    assert_response :success
  end

  test "should get consent" do
    get :consent
    assert_response :success
  end

  test "should revoke consent for research participant" do
    assert_not_nil @participant.accepted_consent_at
    assert_not_nil @participant.accepted_privacy_policy_at
    login(@participant)
    post :revoke_consent
    @participant.reload
    assert_nil @participant.accepted_consent_at
    assert_nil @participant.accepted_privacy_policy_at
    assert_not_nil flash[:notice]
    assert_redirected_to account_path
  end

  test "should not revoke consent for logged out user" do
    post :revoke_consent
    assert_redirected_to new_user_session_path
  end

  test "should get terms and conditions for logged out user" do
    get :terms_and_conditions
    assert_response :success
  end

  test "should get terms and conditions for regular user" do
    login(@regular_user)
    get :terms_and_conditions
    assert_response :success
  end

  test "should get terms of access for logged out user" do
    get :terms_of_access
    assert_response :success
  end

  # TODO add test for terms of access accept/refute, add test for registration path

  test "should mark consent and then privacy policy as read for user" do
    login(@regular_user)

    refute @regular_user.ready_for_research?

    get :consent

    assert_response :success
    assert_template "consent"


    post :consent, consent_read: true
    refute @regular_user.reload.ready_for_research?

    get :privacy_policy

    assert_response :success
    assert_template "privacy_policy"

    post :privacy_policy, privacy_policy_read: true
    assert @regular_user.reload.ready_for_research?

    assert_redirected_to surveys_path
  end

  test "should mark privacy and then consent as read for user" do
    login(@regular_user)

    get :privacy_policy

    assert_response :success
    assert_template "privacy_policy"

    post :privacy_policy, privacy_policy_read: true
    refute @regular_user.reload.ready_for_research?

    get :consent

    assert_response :success
    assert_template "consent"

    post :consent, consent_read: true
    assert @regular_user.reload.ready_for_research?

    assert_redirected_to surveys_path
  end

  test "should mark privacy policy as read and go to consent for user if consent is not read" do
    login(@regular_user)
    post :privacy_policy, privacy_policy_read: true
    @regular_user.reload
    assert_not_nil @regular_user.accepted_privacy_policy_at
    assert_not_nil flash[:notice]
    assert_redirected_to consent_path
  end

  test "should mark consent as read and go to privacy policy for user if privacy policy has not been read" do
    login(@regular_user)
    post :consent, consent_read: true
    @regular_user.reload
    assert_not_nil @regular_user.accepted_consent_at
    assert_not_nil flash[:notice]
    assert_redirected_to privacy_path
  end

  test "should accept privacy during get-started for new user" do
    login(@regular_user)
    assert_nil @regular_user.accepted_privacy_policy_at
    post :accepts_privacy
    @regular_user.reload
    assert_not_nil @regular_user.accepted_privacy_policy_at
    assert_redirected_to get_started_consent_path
  end

  test "should accept consent during get-started for new user" do
    login(@regular_user)
    assert_nil @regular_user.accepted_consent_at
    post :accepts_consent
    @regular_user.reload
    assert_not_nil @regular_user.accepted_consent_at
    assert_redirected_to get_started_about_me_path
  end

  test "should update account information for user" do
    login(users(:social))
    new_last = "Boylston"
    new_first = "Jimmy"
    new_email = "new_email@new.com"
    new_zip_code = "11212"
    new_yob = 1991

    refute_equal new_last, users(:social).last_name
    refute_equal new_first, users(:social).first_name
    refute_equal new_email, users(:social).email
    refute_equal new_zip_code, users(:social).zip_code
    refute_equal new_yob, users(:social).year_of_birth

    patch :update, user: { first_name: new_first, last_name: new_last, email: new_email, zip_code: new_zip_code, year_of_birth: new_yob }

    users(:social).reload

    assert_equal new_last, users(:social).last_name
    assert_equal new_first, users(:social).first_name
    assert_equal new_email, users(:social).email
    assert_equal new_zip_code, users(:social).zip_code
    assert_equal new_yob, users(:social).year_of_birth
  end

  test "should not update account for regular user with invalid user information" do
    login(@regular_user)

    patch :update, user: { email: "" }

    assert_equal :user_info, assigns(:update_for)

    assert_template "account"
  end

  test "should change password for regular user" do
    login(@regular_user)

    patch :change_password, user: { current_password: 'password', password: 'newpassword' }

    assert_equal 'Your password has been changed.', flash[:alert]
    assert_redirected_to account_path
  end

  test "should not change password for regular user with invalid current password" do
    login(@regular_user)

    patch :change_password, user: { current_password: 'invalid', password: 'newpassword' }

    assert_equal :password, assigns(:update_for)
    assert_template "account"
  end

end
