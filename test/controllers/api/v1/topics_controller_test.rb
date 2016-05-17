# frozen_string_literal: true

require 'test_helper'

class Api::V1::TopicsControllerTest < ActionController::TestCase

  setup do
    @user = users(:user_2)
    @forum = forums(:one)
    @topic = topics(:one)
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success

    topics = json_response['topics']
    topic = topics[0]
    assert topics.is_a?(Array)
    assert topic.key?('id')
    assert topic.key?('forum')
    assert topic.key?('name')
    assert topic.key?('slug')
    assert topic.key?('user')
    assert topic.key?('user_photo_url')
    assert topic.key?('pinned')
    assert topic.key?('locked')
    assert topic.key?('postCount')
    assert topic.key?('viewCount')
    assert topic.key?('last_post_at')
  end

  test "should show topic" do
    get :show, id: @topic.id, format: :json
    assert_response :success

    assert_equal @topic.id, json_response['id']
    assert_equal @topic.forum.name, json_response['forum']
    assert_equal @topic.name, json_response['name']
    assert_equal @topic.slug, json_response['slug']
    assert_equal @topic.user.forum_name, json_response['user']
    assert_equal @topic.user.api_photo_url, json_response['user_photo_url']
    assert_equal @topic.pinned, json_response['pinned']
    assert_equal @topic.locked, json_response['locked']
    assert_equal @topic.posts.current.count, json_response['postCount']
    assert_equal @topic.views_count, json_response['viewCount']
    assert_equal @topic.posts.current.last.created_at.strftime("%Y-%m-%d %I:%M %p"), json_response['last_post_at']
  end

  test "should create topic for logged in user" do
    login(@user)
    assert_difference('Topic.count') do
      post :create, forum_id: @forum.id, topic: { name: "new topic", description: "this is a new forum topic" }, format: :json
    end

    assert_equal assigns(:topic).id, json_response['id']
    assert_equal assigns(:topic).forum.name, json_response['forum']
    assert_equal assigns(:topic).name, json_response['name']
    assert_equal assigns(:topic).slug, json_response['slug']
    assert_equal assigns(:topic).user.forum_name, json_response['user']
    assert_equal assigns(:topic).user.api_photo_url, json_response['user_photo_url']
    assert_equal assigns(:topic).pinned, json_response['pinned']
    assert_equal assigns(:topic).locked, json_response['locked']
    assert_equal assigns(:topic).posts.current.count, json_response['postCount']
    assert_equal assigns(:topic).views_count, json_response['viewCount']
    assert_equal assigns(:topic).posts.current.last.created_at.strftime("%Y-%m-%d %I:%M %p"), json_response['last_post_at']
  end

  test "should not create topic without name" do
    login(@user)
    assert_no_difference('Topic.count') do
      post :create, forum_id: @forum.id, topic: { name: "", description: "this is a new forum topic" }, format: :json
    end

    assert_not_nil assigns(:topic)
    assert assigns(:topic).errors.size > 0
    assert_equal ["The title cannot be blank"], json_response['name']
    assert_response :unprocessable_entity
  end

  test "should not create topic without description" do
    login(@user)
    assert_no_difference('Topic.count') do
      post :create, forum_id: @forum.id, topic: { name: "new topic", description: "" }, format: :json
    end

    assert_not_nil assigns(:topic)
    assert assigns(:topic).errors.size > 0
    assert_equal ["can't be blank"], json_response['description']
    assert_response :unprocessable_entity
  end

  test "should not create topic for logged out user" do
    assert_no_difference('Topic.count') do
      post :create, forum_id: @forum.id, topic: { name: "new topic", description: "this is a new forum topic" }, format: :json
    end

    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

end
