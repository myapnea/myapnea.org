require "test_helper"

class ForumsControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @valid_user = users(:user_1)
  end

  def forum
    @forum ||= forums :one
  end

  test "should get index for logged out user" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forums)
  end

  test "should get index for valid user" do
    login(@valid_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:forums)
  end

  test "should get index for owner" do
    login(@owner)
    get :index
    assert_response :success
    assert_not_nil assigns(:forums)
  end

  test "should not get new for logged out user" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should not get new for valid user" do
    login(@valid_user)
    get :new
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test "should get new for owner" do
    login(@owner)
    get :new
    assert_response :success
  end

  test "should not create forum for logged out" do
    assert_difference('Forum.count', 0) do
      post :create, forum: { name: "Sleep Habits", description: "Discuss your sleep habits.", slug: 'sleep-habits', position: 2 }
    end

    assert_redirected_to new_user_session_path
  end

  test "should not create forum for valid user" do
    login(@valid_user)

    assert_difference('Forum.count', 0) do
      post :create, forum: { name: "Sleep Habits", description: "Discuss your sleep habits.", slug: 'sleep-habits', position: 2 }
    end

    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test "should create forum for owner" do
    login(@owner)

    assert_difference('Forum.count') do
      post :create, forum: { name: "Sleep Habits", description: "Discuss your sleep habits.", slug: 'sleep-habits', position: 2 }
    end

    assert_not_nil assigns(:forum)
    assert_equal @owner, assigns(:forum).user

    assert_redirected_to forum_path(assigns(:forum))
  end

  test "should show forum and increase views count" do
    get :show, id: forum
    assert_not_nil assigns(:forum)
    assert_equal 2, assigns(:forum).views_count
    assert_response :success
  end

  test "should show forum for logged out user" do
    get :show, id: forum
    assert_not_nil assigns(:forum)
    assert_response :success
  end

  test "should show forum for valid user" do
    login(@valid_user)
    get :show, id: forum
    assert_not_nil assigns(:forum)
    assert_response :success
  end

  test "should show forum for owner" do
    login(@owner)
    get :show, id: forum
    assert_not_nil assigns(:forum)
    assert_response :success
  end

  test "should not show forum for user who has not accepted terms and conditions" do
    login(users(:created_today))
    get :show, id: forum
    assert_not_nil assigns(:forum)
    assert_redirected_to terms_and_conditions_path
  end

  test "should not get edit for logged out user" do
    get :edit, id: forum
    assert_nil assigns(:forum)
    assert_redirected_to new_user_session_path
  end

  test "should not get edit for valid user" do
    login(@valid_user)
    get :edit, id: forum
    assert_nil assigns(:forum)
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test "should get edit for owner" do
    login(@owner)
    get :edit, id: forum
    assert_not_nil assigns(:forum)
    assert_response :success
  end

  test "should not update forum for logged out user" do
    put :update, id: forum, forum: { name: 'Intro', description: 'Tell Us an Intro', slug: 'intro', position: 1 }
    assert_redirected_to new_user_session_path
  end

  test "should not update forum for valid user" do
    login(@valid_user)
    put :update, id: forum, forum: { name: 'Intro', description: 'Tell Us an Intro', slug: 'intro', position: 1 }
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test "should update forum for owner" do
    login(@owner)
    put :update, id: forum, forum: { name: 'Intro', description: 'Tell Us an Intro', slug: 'intro', position: 1 }
    assert_redirected_to forum_path(assigns(:forum))
  end

  test "should not destroy forum for logged out user" do
    assert_difference('Forum.current.count', 0) do
      delete :destroy, id: forum
    end

    assert_redirected_to new_user_session_path
  end

  test "should not destroy forum for valid user" do
    login(@valid_user)
    assert_difference('Forum.current.count', 0) do
      delete :destroy, id: forum
    end
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end


  test "should destroy forum for owner" do
    login(@owner)
    assert_difference('Forum.current.count', -1) do
      delete :destroy, id: forum
    end

    assert_redirected_to forums_path
  end
end
