require 'test_helper'

class ApiControllerTest < ActionController::TestCase

  setup do
    @user = users(:user_2)
    @forum = forums(:one)
    @topic = topics(:one)
    @rt = research_topics(:rt1)
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
    login(users(:has_launched_survey))
    @survey = surveys(:new)
    @answer_session = answer_sessions(:launched)

    get :survey_answer_sessions, format: :json
    assert_response :success

    answer_session = json_response['answer_sessions'][0]
    assert_equal @answer_session.id, answer_session['id']
    assert_equal @answer_session.survey_id, answer_session['survey_id']
    assert_equal @answer_session.survey.name, answer_session['survey_name']
    assert_equal @answer_session.encounter, answer_session['encounter']
    assert_equal @answer_session.locked, answer_session['locked']
  end

  test "should not get answer sessions for logged out user" do
    get :survey_answer_sessions, format: :json
    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  ## Research Topics

  test "should get research topic index" do
    get :research_topic_index, format: :json
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
    get :research_topic_show, research_topic_id: @rt.id, format: :json
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
      post :research_topic_create, research_topic: { text: "new rt", description: "this is a new research topic" }, format: :json
    end

    assert_equal assigns(:new_research_topic).id, json_response['id']
    assert_equal assigns(:new_research_topic).text, json_response['title']
    assert_equal assigns(:new_research_topic).description, json_response['description']
    assert_equal assigns(:new_research_topic).endorsement, json_response['endorsement']
    assert_equal assigns(:new_research_topic).votes.current.count, json_response['votes']
    assert_equal assigns(:new_research_topic).voted_by_user?(@user), json_response['voted_by_me']
    assert_equal assigns(:new_research_topic).topic.posts.current.count, json_response['comments']
    assert_equal assigns(:new_research_topic).user.forum_name, json_response['user']
    assert_equal assigns(:new_research_topic).user.api_photo_url, json_response['user_photo_url']
  end

  test "should not create research topic without text" do
    login(@user)
    assert_no_difference('ResearchTopic.count') do
      post :research_topic_create, research_topic: { text: "", description: "this is a new research topic" }, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not create research topic without description" do
    login(@user)
    assert_no_difference('ResearchTopic.count') do
      post :research_topic_create, research_topic: { text: "new rt", description: "" }, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not create research topic for logged out user" do
    assert_no_difference('ResearchTopic.count') do
      post :research_topic_create, research_topic: { text: "new rt", description: "this is a new research topic" }, format: :json
    end

    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  ## Votes

  test "should get votes" do
    get :votes, format: :json
    assert_response :success
  end

  test "should endorse research topics by casting vote for user" do
    login(@user)
    assert_difference('Vote.where(rating: 1).count') do
      post :vote, research_topic_id: @rt.id, endorse: "1", format: :json
    end

    assert_equal true, json_response['success']
  end

  test "should oppose research topics by casting vote for user" do
    login(@user)
    assert_difference('Vote.where(rating: 0).count') do
      post :vote, research_topic_id: @rt.id, endorse: "0", format: :json
    end

    assert_equal true, json_response['success']
  end

  test "should cast vote for user with comment" do
    login(@user)
    assert_difference('Vote.count') do
      assert_difference('Post.count') do
        post :vote, research_topic_id: @rt.id, endorse: "1", comment: "sample comment", format: :json
      end
    end

    assert_equal true, json_response['success']
  end

  test "should not cast vote for user without endorse value" do
    login(@user)
    assert_no_difference('Vote.count') do
      post :vote, research_topic_id: @rt.id, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not cast vote for user without research topic" do
    login(@user)
    assert_no_difference('Vote.count') do
      post :vote, endorse: "1", format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not cast vote for logged out user" do
    assert_no_difference('Vote.count') do
      post :vote, research_topic_id: @rt.id, endorse: "1", format: :json
    end
  end


  ## Topics

  test "should get topic index" do
    get :topic_index, format: :json
    assert_response :success

    topics = json_response['topics']
    topic = topics[0]
    assert topics.kind_of?(Array)
    assert topic.has_key?('id')
    assert topic.has_key?('forum')
    assert topic.has_key?('name')
    assert topic.has_key?('slug')
    assert topic.has_key?('user')
    assert topic.has_key?('user_photo_url')
    assert topic.has_key?('pinned')
    assert topic.has_key?('locked')
    assert topic.has_key?('postCount')
    assert topic.has_key?('viewCount')
    assert topic.has_key?('last_post_at')
  end

  test "should get topic show" do
    get :topic_show, topic_id: @topic.id, format: :json
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
    assert_equal @topic.posts.current.last.created_at.strftime("%Y-%m-%d"), json_response['last_post_at']
  end

  test "should create topic for logged in user" do
    login(@user)
    assert_difference('Topic.count') do
      post :topic_create, forum_id: @forum.id, topic: { name: "new topic", description: "this is a new forum topic" }, format: :json
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
    assert_equal assigns(:topic).posts.current.last.created_at.strftime("%Y-%m-%d"), json_response['last_post_at']
  end

  test "should not create topic without name" do
    login(@user)
    assert_no_difference('Topic.count') do
      post :topic_create, forum_id: @forum.id, topic: { name: "", description: "this is a new forum topic" }, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not create topic without description" do
    login(@user)
    assert_no_difference('Topic.count') do
      post :topic_create, forum_id: @forum.id, topic: { name: "new topic", description: "" }, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not create topic for logged out user" do
    assert_no_difference('Topic.count') do
      post :topic_create, forum_id: @forum.id, topic: { name: "new topic", description: "this is a new forum topic" }, format: :json
    end

    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

  ## Posts

  test "should create post for logged in user" do
    login(@user)
    assert_difference('Post.count') do
      post :post_create, topic_id: @topic.id, post: { description: "this is a new forum topic" }, format: :json
    end

    assert_equal assigns(:post).id, json_response['id']
    assert_equal assigns(:post).description, json_response['description']
    assert_equal assigns(:post).created_at.strftime("%Y-%m-%d"), json_response['created_at']
    assert_equal assigns(:post).links_enabled, json_response['links_enabled']
    assert_equal assigns(:post).user.forum_name, json_response['user']
    assert_equal assigns(:post).user.api_photo_url, json_response['user_photo_url']
  end

  test "should not create post without description" do
    login(@user)
    assert_no_difference('Post.count') do
      post :post_create, topic_id: @topic.id, post: { description: "" }, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not create post without topic id" do
    login(@user)
    assert_no_difference('Post.count') do
      post :post_create, topic_id: nil, post: { description: "this is a new post" }, format: :json
    end

    assert_equal false, json_response['success']
  end

  test "should not create post for logged out user" do
    assert_no_difference('Post.count') do
      post :post_create, topic_id: @topic.id, post: { description: "this is a new forum topic" }, format: :json
    end

    assert_equal 'You need to sign in or sign up before continuing.', json_response['error']
  end

end
