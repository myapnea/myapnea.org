require "test_helper"

class TopicsControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @valid_user = users(:user_1)
  end

  def topic
    @topic ||= topics :one
  end

  test "should get index and redirect to forum" do
    skip
    get :index
    assert_redirected_to assigns(:forum)
  end

  test "should not get new for anonymous user" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get new for valid user" do
    login(@valid_user)
    get :new
    assert_response :success
  end

  test "should get new for owner" do
    login(@owner)
    get :new
    assert_response :success
  end

  def test_create
    skip
    assert_difference('Topic.count') do
      post :create, topic: { forum_id: topic.forum_id, last_post_at: topic.last_post_at, locked: topic.locked, name: topic.name, pinned: topic.pinned, slug: topic.slug, state: topic.state, user_id: topic.user_id, views_count: topic.views_count }
    end

    assert_redirected_to topic_path(assigns(:topic))
  end

  def test_show
    skip
    get :show, id: topic
    assert_response :success
  end

  def test_edit
    skip
    get :edit, id: topic
    assert_response :success
  end

  def test_update
    skip
    put :update, id: topic, topic: { forum_id: topic.forum_id, last_post_at: topic.last_post_at, locked: topic.locked, name: topic.name, pinned: topic.pinned, slug: topic.slug, state: topic.state, user_id: topic.user_id, views_count: topic.views_count }
    assert_redirected_to topic_path(assigns(:topic))
  end

  def test_destroy
    skip
    assert_difference('Topic.count', -1) do
      delete :destroy, id: topic
    end

    assert_redirected_to topics_path
  end
end
