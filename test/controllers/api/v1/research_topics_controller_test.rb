require 'test_helper'

class Api::V1::ResearchTopicsControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_2)
    @rt = research_topics(:rt1)
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  test "should get research topic index" do
    get :index, format: :json
    assert_response :success

    rt = json_response['research_topics'][0]
    assert_equal @rt.id, rt['id']
    assert_equal @rt.text, rt['title']
    assert_equal @rt.description, rt['description']
    assert_equal @rt.endorsement, rt['endorsement']
    assert_equal @rt.votes.current.count, rt['votes']
    assert_equal @rt.voted_by_user?(@user), rt['voted_by_me']
    assert_equal @rt.topic.posts.current.count, rt['comments']
    assert_equal @rt.user.forum_name, rt['user']
    assert_equal @rt.user.api_photo_url, rt['user_photo_url']
  end

  test "should get research topic show" do
    login(@user)
    get :show, id: @rt.id, format: :json
    assert_response :success

    assert_equal @rt.id, json_response['id']
    assert_equal @rt.text, json_response['title']
    assert_equal @rt.description, json_response['description']
    assert_equal @rt.endorsement, json_response['endorsement']
    assert_equal @rt.votes.current.count, json_response['votes']
    assert_equal @rt.voted_by_user?(@user), json_response['voted_by_me']
    assert_equal @rt.topic.posts.current.count, json_response['comments']
    assert_equal @rt.user.forum_name, json_response['user']
    assert_equal @rt.user.api_photo_url, json_response['user_photo_url']
  end

  test "should create research topic for logged in user" do
    login(@user)
    assert_difference('ResearchTopic.count') do
      post :create, research_topic: { text: "new rt", description: "this is a new research topic" }, format: :json
    end

    assert_equal assigns(:research_topic).id, json_response['id']
    assert_equal assigns(:research_topic).text, json_response['title']
    assert_equal assigns(:research_topic).description, json_response['description']
    assert_equal assigns(:research_topic).endorsement, json_response['endorsement']
    assert_equal assigns(:research_topic).votes.current.count, json_response['votes']
    assert_equal assigns(:research_topic).voted_by_user?(@user), json_response['voted_by_me']
    assert_equal assigns(:research_topic).topic.posts.current.count, json_response['comments']
    assert_equal assigns(:research_topic).user.forum_name, json_response['user']
    assert_equal assigns(:research_topic).user.api_photo_url, json_response['user_photo_url']
  end

  test "should not create research topic without text" do
    login(@user)
    assert_no_difference('ResearchTopic.count') do
      post :create, research_topic: { text: "", description: "this is a new research topic" }, format: :json
    end

    assert_not_nil assigns(:research_topic)
    assert assigns(:research_topic).errors.size > 0
    assert_equal ["can't be blank"], json_response['text']
    assert_response :unprocessable_entity
  end

  test "should not create research topic without description" do
    login(@user)
    assert_no_difference('ResearchTopic.count') do
      post :create, research_topic: { text: "new rt", description: "" }, format: :json
    end

    assert_not_nil assigns(:research_topic)
    assert assigns(:research_topic).errors.size > 0
    assert_equal ["can't be blank"], json_response['description']
    assert_response :unprocessable_entity
  end

  test "should not create research topic for logged out user" do
    assert_no_difference('ResearchTopic.count') do
      post :create, research_topic: { text: "new rt", description: "this is a new research topic" }, format: :json
    end

    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  ## Votes

  test "should endorse research topics by casting vote for user" do
    login(@user)
    assert_difference('Vote.where(rating: 1).count') do
      post :vote, id: @rt.id, endorse: "1", format: :json
    end

    assert_equal true, json_response['success']
  end

  test "should oppose research topics by casting vote for user" do
    login(@user)
    assert_difference('Vote.where(rating: 0).count') do
      post :vote, id: @rt.id, endorse: "0", format: :json
    end

    assert_equal true, json_response['success']
  end

  test "should cast vote for user with comment" do
    login(@user)
    assert_difference('Vote.count') do
      assert_difference('Post.count') do
        post :vote, id: @rt.id, endorse: "1", comment: "sample comment", format: :json
      end
    end

    assert_equal true, json_response['success']
  end

  test "should not cast vote for user without endorse value" do
    login(@user)
    assert_no_difference('Vote.count') do
      post :vote, id: @rt.id, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not cast vote for user without research topic" do
    login(@user)
    assert_no_difference('Vote.count') do
      post :vote, endorse: "1", format: :json
    end

    assert_response 204
  end

  test "should not cast vote for logged out user" do
    assert_no_difference('Vote.count') do
      post :vote, id: @rt.id, endorse: "1", format: :json
    end
  end

end
