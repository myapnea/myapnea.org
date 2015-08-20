require 'test_helper.rb'

class AdminControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  test "should get providers as owner" do
    login(@owner)
    get :providers
    assert_not_nil assigns(:providers)
    assert_response :success
  end

  test "should get research topics as owner" do
    login(@owner)
    get :research_topics
    assert_not_nil assigns(:research_topics)
    assert_response :success
  end

  test "should get daily demographic breakdown as owner" do
    login(@owner)
    xhr :get, :daily_demographic_breakdown, breakdown_date_start: { "(1i)" => '2014', "(2i)" => "8", "(3i)" => "20" }, breakdown_date_end: { "(1i)" => '2015', "(2i)" => "8", "(3i)" => "20" }, format: 'js'
    assert_not_nil assigns(:date1)
    assert_not_nil assigns(:date2)
    assert_response :success
  end

  test "should get daily engagement data as owner" do
    login(@owner)
    xhr :get, :daily_engagement_data
    assert_not_nil assigns(:posts)
    assert_not_nil assigns(:surveys)
    assert_not_nil assigns(:users)
    assert_response :success
  end

  test "should get progress report as owner" do
    login(@owner)
    get :progress_report
    assert_response :success
  end

  test "should get dashboard as owner" do
    login(@owner)
    get :dashboard
    assert_response :success
  end

  test "should get dashboard as moderator" do
    login(@moderator)
    get :dashboard
    assert_response :success
  end

  test "should not get dashboard as regular user" do
    login(@regular_user)
    get :dashboard
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test "should not get dashboard as logged out user" do
    get :dashboard
    assert_redirected_to new_user_session_path
  end

  test "should get admin surveys as owner" do
    login(users(:owner))
    get :surveys
    assert_response :success
  end

  test "should get admin surveys as moderator" do
    login(users(:moderator_1))
    get :surveys
    assert_response :success
  end

  test "should not get admin surveys for regular user" do
    login(users(:user_1))
    get :surveys
    assert_redirected_to root_path
  end

  test "should unlock survey for user as owner" do
    login(users(:owner))
    post :unlock_survey, user_id: users(:adult_diagnosed), answer_session_id: answer_sessions(:locked)

    answer_sessions(:locked).reload

    assert_not_nil assigns(:user)
    assert_equal false, answer_sessions(:locked).locked?
    assert_redirected_to assigns(:user)
  end

  test "should not unlock survey for without user as owner" do
    login(users(:owner))
    post :unlock_survey, user_id: -1, answer_session_id: answer_sessions(:locked)

    answer_sessions(:locked).reload

    assert_nil assigns(:user)
    assert_equal true, answer_sessions(:locked).locked?
    assert_redirected_to users_path
  end

  test "should unlock survey for user as moderator" do
    login(users(:moderator_1))
    post :unlock_survey, user_id: users(:adult_diagnosed), answer_session_id: answer_sessions(:locked)

    answer_sessions(:locked).reload

    assert_not_nil assigns(:user)
    assert_equal false, answer_sessions(:locked).locked?
    assert_redirected_to assigns(:user)
  end

  test "should not unlock survey for user as regular user" do
    login(users(:user_1))
    post :unlock_survey, user_id: users(:adult_diagnosed), answer_session_id: answer_sessions(:locked)

    answer_sessions(:locked).reload

    assert_nil assigns(:user)
    assert_equal true, answer_sessions(:locked).locked?
    assert_redirected_to root_path
  end

  test "should get admin timeline report as admin" do
    login(users(:moderator_1))
    get :timeline
    assert_response :success
  end

  test "should get location report as admin" do
    login(users(:moderator_1))
    get :location
    assert_response :success
  end

  test "should get cross tabs as owner" do
    login(users(:owner))
    get :cross_tabs
    assert_response :success
  end

  test "should get engagement report as admin" do
    login(users(:moderator_1))

    get :engagement_report
    assert_response :success
  end

  test "should get daily engagement report as owner" do
    login(users(:owner))

    get :daily_engagement
    assert_response :success
  end

  test "should NOT get daily engagement report as moderator" do
    login(users(:moderator_1))

    get :daily_engagement
    assert_redirected_to :admin
  end

end
