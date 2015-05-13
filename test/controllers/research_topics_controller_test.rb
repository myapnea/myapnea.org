require 'test_helper'

class ResearchTopicsControllerTest < ActionController::TestCase

  setup do
    @no_votes_user = users(:user_2)
    @novice_user = users(:user_4)
    @experienced_user = users(:user_1)

  end

  # Index

  test "should get index for experienced user" do
    # Displays normal index
    login(@experienced_user)
    get :index
    assert_not_nil assigns(:research_topics)
    assert_response :success
  end

  test "should redirect to intro action for no_votes user" do
    login(@no_votes_user)
    get :index
    assert_redirected_to intro_research_topics_path
  end

  test "should redirect to first_topics action for novice_user" do
    login(@novice_user)
    get :index
    assert_redirected_to first_topics_research_topics_path
  end


  # Intro

  test "should get intro for no_votes user" do
    # page explaining rank the research and allowing user to press "get started"
    login(@no_votes_user)

    get :intro

    assert_response :success

  end


  # First Topics
  test "should get first topics for novice user" do
    ResearchTopic.load_seeds
    login(@novice_user)

    get :first_topics

    assert_response :success

  end

  test "should get first topics for no_votes user that read the intro" do
    ResearchTopic.load_seeds
    login(@no_votes_user)

    get :first_topics, read_intro: 1

    assert_response :success
  end

  test "should redirect no_votes user to intro if they haven't read the intro" do
    login(@no_votes_user)

    get :first_topics

    assert_redirected_to intro_research_topics_path
  end

  # Not sure this is the best course of action:
  test "should redirect from first topics to index for experienced users" do
    login(@experienced_user)

    get :first_topics

    assert_redirected_to research_topics_path

  end

  # Newest
  test "should get newest for experienced user" do
    login(@experienced_user)

    get :newest

    assert_response :success
  end

  test "should redirect from newest to intro action for no_votes user" do
    login(@no_votes_user)

    get :newest

    assert_redirected_to intro_research_topics_path
  end

  test "should redirect from newest to first_topics action for novice_user" do
    login(@novice_user)

    get :newest

    assert_redirected_to first_topics_research_topics_path
  end

  # Most Discussed
  test "should get most_discussed for experienced user" do
    login(@experienced_user)

    get :most_discussed

    assert_response :success
  end

  test "should redirect from most discussed to intro action for no_votes user" do
    login(@no_votes_user)

    get :most_discussed

    assert_redirected_to intro_research_topics_path
  end

  test "should redirect from most discussed to first_topics action for novice_user" do
    login(@novice_user)

    get :most_discussed

    assert_redirected_to first_topics_research_topics_path
  end


  # Creation

  test "should create a research topic as experienced user" do
    login(@experienced_user)
    assert_difference('ResearchTopic.count') do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important'}
    end

    assert_response :success
  end

  test "should not create research topic as novice user" do
    login(@novice_user)

    assert_no_difference('ResearchTopic.count') do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important'}
    end


  end

  test "should not create research topic as no votes user" do
    login(@no_votes_user)

    assert_no_difference('ResearchTopic.count') do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important'}
    end
  end

  test "should not create research topic as logged out user" do
    assert_no_difference('ResearchTopic.count') do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important' }
    end

  end


  # Endorsement
  # Test w/ and w/o comment

  test "should endorse any approved research topic as experienced user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'

    login(@experienced_user)

    assert_nil research_topics(:rt2).endorsement

    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, endorse: 1, format: 'js'
    end

    assert_equal 1.0, research_topics(:rt2).endorsement

    assert_not_nil assigns(:research_topic)

    assert_response 302
  end

  test "should add comment when voting for topic" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'

    login(@experienced_user)
    comment = "Hi there i'm commenting"

    assert_difference "Post.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, endorse: 1, comment: comment, format: 'js'
    end

    assert_equal comment, research_topics(:rt2).topic.posts.last.description

  end

  test "should vote for only the seeded research topics as a no_votes user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'
    login(@no_votes_user)
    ResearchTopic.load_seeds
    rt = ResearchTopic.where(category: "seeded").first


    assert_no_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, endorse: 1, format: 'js'
    end

    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: rt.id, endorse: 1, format: 'js'
    end

  end


  test "should vote for only the seeded research topics as a novice user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'
    login(@novice_user)
    ResearchTopic.load_seeds
    rt = ResearchTopic.where(category: "seeded").first


    assert_no_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, endorse: 1, format: 'js'
    end

    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: rt.id, endorse: 1, format: 'js'
    end

  end


  # Opposition
  test "should oppose any approved research topic as experienced user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'
    login(@experienced_user)

    assert_nil research_topics(:rt2).endorsement

    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, endorse: 0, format: 'js'
    end

    assert_equal 0.0, research_topics(:rt2).endorsement

    assert_not_nil assigns(:research_topic)

    assert_response 302
  end





end
