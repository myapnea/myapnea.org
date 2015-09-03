require 'test_helper'

class Api::V1::PostsControllerTest < ActionController::TestCase

  setup do
    @user = users(:user_2)
    @forum = forums(:one)
    @topic = topics(:one)
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "should create post for logged in user" do
    login(@user)
    assert_difference('Post.count') do
      post :create, topic_id: @topic.id, post: { description: "this is a new forum topic" }, format: :json
    end

    assert_equal assigns(:post).id, json_response['id']
    assert_equal assigns(:post).description, json_response['description']
    assert_equal assigns(:post).created_at.strftime("%Y-%m-%d %I:%M %p"), json_response['created_at']
    assert_equal assigns(:post).links_enabled, json_response['links_enabled']
    assert_equal assigns(:post).user.forum_name, json_response['user']
    assert_equal assigns(:post).user.api_photo_url, json_response['user_photo_url']
  end

  test "should not create post without description" do
    login(@user)
    assert_no_difference('Post.count') do
      post :create, topic_id: @topic.id, post: { description: "" }, format: :json
    end

    assert_not_nil assigns(:post)
    assert assigns(:post).errors.size > 0
    assert_equal ["can't be blank"], json_response['description']
    assert_response :unprocessable_entity
  end

  test "should not create post without topic id" do
    login(@user)
    assert_no_difference('Post.count') do
      post :create, topic_id: '', post: { description: "this is a new post" }, format: :json
    end

    assert_response 204
  end

  test "should not create post for logged out user" do
    assert_no_difference('Post.count') do
      post :create, topic_id: @topic.id, post: { description: "this is a new forum topic" }, format: :json
    end

    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

end
