# frozen_string_literal: true

require "test_helper"

# Tests to assure that community members can create and view forum topics.
class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topic = topics(:one)
    @regular_user = users(:user_1)
  end

  def topic_params
    {
      title: "New Topic Title",
      slug: "new-topic-title",
      description: "This is the my new forum topic.",
      pinned: "1"
    }
  end

  test "should subscribe to notifications" do
    login(users(:valid))
    post subscription_topic_url(@topic, format: "js"), params: { notify: "1" }
    assert_not_nil assigns(:topic)
    assert_equal true, assigns(:topic).subscribed?(users(:valid))
    assert_template "subscription"
    assert_response :success
  end

  test "should unsubscribe from notifications" do
    login(users(:valid))
    post subscription_topic_url(@topic, format: "js"), params: { notify: "0" }
    assert_not_nil assigns(:topic)
    assert_equal false, assigns(:topic).subscribed?(users(:valid))
    assert_template "subscription"
    assert_response :success
  end

  test "should not subscribe for anonymous user" do
    post subscription_topic_url(@topic, format: "js"), params: { notify: "1" }
    assert_template nil
    assert_response :unauthorized
  end

  test "should get index" do
    login(@regular_user)
    get topics_url
    assert_response :success
    assert_not_nil assigns(:topics)
  end

  test "should get new" do
    login(@regular_user)
    get new_topic_url
    assert_response :success
  end

  test "should create topic" do
    login(@regular_user)
    assert_difference("Topic.count") do
      post topics_url, params: { topic: topic_params }
    end
    assert_not_nil assigns(:topic)
    assert_equal "New Topic Title", assigns(:topic).title
    assert_equal "This is the my new forum topic.", assigns(:topic).replies.first.description
    assert_equal users(:user_1), assigns(:topic).user
    assert_redirected_to assigns(:topic)
  end

  test "should not create topic with blank title" do
    login(@regular_user)
    assert_difference("Topic.count", 0) do
      post topics_url, params: { topic: topic_params.merge(title: "") }
    end
    assert_template "new"
    assert_response :success
  end

  test "should shadow ban new spammer" do
    login(users(:new_spammer))
    assert_difference("Topic.count") do
      post topics_url, params: {
        topic: {
          title: "http://www.example.com",
          slug: "http-www-example-com",
          description: "http://www.example.com" }
        }
    end
    assert_equal true, assigns(:topic).user.shadow_banned
    assert_redirected_to assigns(:topic)
  end

  test "should not shadow ban verified user" do
    login(users(:verified_user))
    assert_difference("Topic.count") do
      post topics_url, params: {
        topic: {
          title: "http://www.example.com",
          slug: "http-www-example-com",
          description: "http://www.example.com" }
        }
    end
    assert_equal false, assigns(:topic).user.shadow_banned
    assert_redirected_to assigns(:topic)
  end

  test "should show topic" do
    login(@regular_user)
    get topic_url(@topic)
    @topic.reload
    assert_equal 1, @topic.view_count
    assert_response :success
  end

  test "should increase topic view count as public viewer" do
    get topic_url(@topic)
    @topic.reload
    assert_equal 1, @topic.view_count
    assert_response :success
  end

  test "should not increase topic view count as spammer" do
    login(users(:shadow_banned))
    get topic_url(@topic)
    @topic.reload
    assert_equal 0, @topic.view_count
    assert_response :success
  end

  test "should get edit" do
    login(@regular_user)
    get edit_topic_url(@topic)
    assert_response :success
  end

  test "should update topic" do
    login(@regular_user)
    patch topic_url(@topic), params: { topic: topic_params.merge(title: "Updated Topic Title") }
    assert_redirected_to assigns(:topic)
  end

  test "should not update topic with blank title" do
    login(@regular_user)
    patch topic_url(@topic), params: { topic: topic_params.merge(title: "") }
    assert_template "edit"
    assert_response :success
  end

  test "should destroy topic" do
    login(@regular_user)
    assert_difference("Topic.current.count", -1) do
      delete topic_url(@topic)
    end
    assert_redirected_to topics_path
  end
end
