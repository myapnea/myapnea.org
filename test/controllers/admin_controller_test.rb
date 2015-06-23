require 'test_helper.rb'

class AdminControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  test "should get progress report for owner" do
    login(@owner)
    get :progress_report
    assert_response :success
  end

  test "should get dashboard for owner" do
    login(@owner)
    get :dashboard
    assert_response :success
  end

  test "should get dashboard for moderator" do
    login(@moderator)
    get :dashboard
    assert_response :success
  end

  test "should not get dashboard for regular user" do
    login(@regular_user)
    get :dashboard
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test "should not get dashboard for logged out user" do
    get :dashboard
    assert_redirected_to new_user_session_path
  end

  test "Owners should GET survey overview" do
    login(users(:owner))

    get :surveys
    assert_response :success
  end

  test "Moderators should GET survey overview" do
    login(users(:moderator_1))

    get :surveys
    assert_response :success
  end


  test "should raise SecurityViolation for unauthorized users" do
    login(users(:user_1))

    get :surveys

    assert_authorization_exception
  end

  test "should get admin version stats" do
    login(users(:moderator_1))

    get :version_stats

    assert_not_nil assigns(:version_dates)

    assert_response :success
  end

  test "should get location report for admin" do
    login(users(:moderator_1))

    get :location
    assert_response :success
  end

  test "should get engagement report for admin" do
    login(users(:moderator_1))

    get :engagement_report
    assert_response :success
  end

end
