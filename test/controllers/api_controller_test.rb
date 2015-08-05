require 'test_helper'

class ApiControllerTest < ActionController::TestCase

  setup do
    @user = users(:user_2)
    @rt = research_topics(:rt1)
    @forum = forums(:one)
    @topic = topics(:one)
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  ## Home
  test "should get home for logged in user" do
    login(@user)
    get :home, format: :json
    assert_response :success
  end

  test "should not get home for logged out user" do
    get :home, format: :json
    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  ## Surveys

  test "should get answer sessions for logged in user" do
    login(@user)
    get :survey_answer_sessions, format: :json
    assert_response :success
  end

  test "should not get answer sessions for logged out user" do
    get :survey_answer_sessions, format: :json
    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  ## Research Topics

  test "should get research topic index" do
    get :research_topic_index, format: :json
    assert_response :success
  end

  test "should get votes" do
    get :votes, format: :json
    assert_response :success
  end

  test "should cast vote for user" do
    login(@user)
    assert_difference('Vote.count') do
      post :vote, research_topic_id: @rt.id, endorse: "1", format: :json
    end
  end

  test "should not cast vote for logged out user" do
    assert_no_difference('Vote.count') do
      post :vote, research_topic_id: @rt.id, endorse: "1", format: :json
    end
  end

  test "should get research topic show" do
    get :research_topic_show, research_topic_id: @rt.id, format: :json
    assert_response :success
  end

  test "should create research topic for logged in user" do
    login(@user)
    assert_difference('ResearchTopic.count') do
      post :research_topic_create, research_topic: { text: "new rt", description: "this is a new research topic" }, format: :json
    end
  end

  test "should not create research topic for logged out user" do
    assert_no_difference('ResearchTopic.count') do
      post :research_topic_create, research_topic: { text: "new rt", description: "this is a new research topic" }, format: :json
    end
  end

  ## Forums

  test "should get topic index" do
    get :topic_index, format: :json
    assert_response :success
  end

  test "should get topic show" do
    get :topic_show, topic_id: @topic.id, format: :json
    assert_response :success
  end

  test "should create topic for logged in user" do
    login(@user)
    assert_difference('Topic.count') do
      post :topic_create, forum_id: @forum.id, topic: { name: "new topic", description: "this is a new forum topic" }, format: :json
    end
  end

  test "should not create topic for logged out user" do
    assert_no_difference('Topic.count') do
      post :topic_create, forum_id: @forum.id, topic: { name: "new topic", description: "this is a new forum topic" }, format: :json
    end
  end

  test "should create post for logged in user" do
    login(@user)
    assert_difference('Post.count') do
      post :post_create, topic_id: @topic.id, post: { description: "this is a new forum topic" }, format: :json
    end
  end

  test "should not create post for logged out user" do
    assert_no_difference('Post.count') do
      post :post_create, topic_id: @topic.id, post: { description: "this is a new forum topic" }, format: :json
    end
  end

end
