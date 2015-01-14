require 'test_helper.rb'

class AdminControllerTest < ActionController::TestCase

  test "Owners should GET user administration" do
    login(users(:owner))

    get :users
    assert_response :success

  end

  test "Moderators should not GET user administration" do
    login(users(:moderator_1))

    get :users

    assert_authorization_exception

  end


  test "should raise SecurityViolation for unauthorized users" do
    login(users(:user_1))

    get :users

    assert_authorization_exception
  end

  test "should export users as owner" do
    login(users(:owner))
    get :export_users, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  test "should not export users as moderator" do
    login(users(:moderator_1))
    get :export_users, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_redirected_to root_path
  end

  test "should not export users as unauthorized users" do
    login(users(:user_1))
    get :export_users, format: 'csv'
    assert_nil assigns(:csv_string)
  end

  test "should not export users for logged out users" do
    get :export_users, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_response :unauthorized
  end

  test "should allow owner to add and remove user roles" do
    login(users(:owner))

    post :add_role_to_user, format: :js, user_id: users(:user_1).id, role: roles(:moderator).name
    assert_response :success
    assert users(:user_1).has_role? :moderator

    post :remove_role_from_user, user_id: users(:moderator_1).id, role: roles(:moderator).name, format: :js
    assert_response :success
    refute users(:moderator_1).has_role? :moderator
  end

  test "should not allow a non-owner to add and remove user roles" do
    login(users(:moderator_1))

    post :add_role_to_user, format: :js, user_id: users(:user_1).id, role: roles(:moderator).name
    assert_authorization_exception
    refute users(:user_1).has_role? :moderator

    post :remove_role_from_user, user_id: users(:moderator_1).id, role: roles(:moderator).name, format: :js
    assert_authorization_exception
    assert users(:moderator_1).has_role? :moderator

    login(users(:user_1))

    post :add_role_to_user, format: :js, user_id: users(:user_1).id, role: roles(:moderator).name
    assert_authorization_exception
    refute users(:user_1).has_role? :moderator

    post :remove_role_from_user, user_id: users(:moderator_1).id, role: roles(:moderator).name, format: :js
    assert_authorization_exception
    assert users(:moderator_1).has_role? :moderator


  end

  test "should allow owner to delete users" do
    login(users(:owner))
    post :destroy_user, user_id: users(:user_1).id, format: :js
    assert_response :success
    assert User.find_by_id(users(:user_1).id).deleted?

    post :destroy_user, user_id: users(:moderator_1).id, format: :js
    assert_response :success
    assert User.find_by_id(users(:moderator_1).id).deleted?

  end

  test "should not allow owner to delete himself" do
    login(users(:owner))
    post :destroy_user, user_id: users(:owner).id, format: :js


    assert_response :success
    assert User.find_by_id(users(:owner).id)

  end

  test "should not allow non-owner to delete users" do
    login(users(:moderator_1))

    post :destroy_user, user_id: users(:user_1).id, format: :js
    assert_authorization_exception
    post :destroy_user, user_id: users(:owner).id, format: :js
    assert_authorization_exception
    post :destroy_user, user_id: users(:moderator_1).id, format: :js
    assert_authorization_exception

    login(users(:user_5))
    post :destroy_user, user_id: users(:user_1).id, format: :js
    assert_authorization_exception
    post :destroy_user, user_id: users(:owner).id, format: :js
    assert_authorization_exception
    post :destroy_user, user_id: users(:moderator_1).id, format: :js
    assert_authorization_exception

  end

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

  # Blog
  test "should get blog admin for moderator" do
    skip "Re-engineering of blog"
    login(users(:moderator_2))

    get :blog

    assert_response :success
    assert_equal Notification.where(post_type: "blog"), assigns(:posts)

  end

  test "should not get blog admin for normal user" do
    login(users(:social))

    get :blog

    assert_authorization_exception
  end

  # Helpers
end
