require 'test_helper.rb'

class AdminControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
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

    get :common
    assert_response :success
  end

  test "Moderators should GET survey overview" do
    login(users(:moderator_1))

    get :common
    assert_response :success
  end


  test "should raise SecurityViolation for unauthorized users" do
    login(users(:user_1))

    get :common

    assert_authorization_exception
  end

  # test "should allow owner to add and remove user roles" do
  #   login(users(:owner))

  #   post :add_role_to_user, format: :js, user_id: users(:user_1).id, role: roles(:moderator).name
  #   assert_response :success
  #   assert users(:user_1).has_role? :moderator

  #   post :remove_role_from_user, user_id: users(:moderator_1).id, role: roles(:moderator).name, format: :js
  #   assert_response :success
  #   refute users(:moderator_1).has_role? :moderator
  # end

  # test "should not allow a non-owner to add and remove user roles" do
  #   login(users(:moderator_1))

  #   post :add_role_to_user, format: :js, user_id: users(:user_1).id, role: roles(:moderator).name
  #   assert_authorization_exception
  #   refute users(:user_1).has_role? :moderator

  #   post :remove_role_from_user, user_id: users(:moderator_1).id, role: roles(:moderator).name, format: :js
  #   assert_authorization_exception
  #   assert users(:moderator_1).has_role? :moderator

  #   login(users(:user_1))

  #   post :add_role_to_user, format: :js, user_id: users(:user_1).id, role: roles(:moderator).name
  #   assert_authorization_exception
  #   refute users(:user_1).has_role? :moderator

  #   post :remove_role_from_user, user_id: users(:moderator_1).id, role: roles(:moderator).name, format: :js
  #   assert_authorization_exception
  #   assert users(:moderator_1).has_role? :moderator


  # end

  # Notifications
  test "should show notification administration to moderator" do
    login(users(:moderator_1))

    get :notifications

    assert_response :success
    assert_equal Notification.where(post_type: "notification"), assigns(:posts)
  end

  test "should not show notification administration to normal user" do
    login(users(:user_1))

    get :notifications

    assert_authorization_exception
  end

  # Research Topics
  test "should show research topic administration to moderator" do
    login(users(:moderator_1))

    get :research_topics

    assert_response :success

  end

  test "should not show research topic administration to normal user" do
    login(users(:user_4))

    get :research_topics

    assert_authorization_exception
  end

end
