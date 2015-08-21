require 'test_helper'

class ResearchTopicsControllerTest < ActionController::TestCase

  setup do
    @no_votes_user = users(:user_2)
    @novice_user = users(:user_4)
    @experienced_user = users(:user_1)

    @rt = research_topics(:rt1)
  end

  # Index

  test "should get index for logged out user" do
    get :index
    assert_response :success
  end

  test "should get accepted_research_topics_index for logged out user" do
    get :accepted_research_topics_index
    assert_response :success
  end

  test "should get sleep_apnea_body_weight for logged out user" do
    get :sleep_apnea_body_weight
    assert_response :success
  end

  test "should get sleep_apnea_brain_plasticity for logged out user" do
    get :sleep_apnea_brain_plasticity
    assert_response :success
  end

  test "should get sleep_apnea_adenotonsillectomy_children for logged out user" do
    get :sleep_apnea_adenotonsillectomy_children
    assert_response :success
  end

  test "should get sleep_apnea_diabetes for logged out user" do
    get :sleep_apnea_diabetes
    assert_response :success
  end

  test "should get sleep_apnea_nighttime_oxygen_use for logged out user" do
    get :sleep_apnea_nighttime_oxygen_use
    assert_response :success
  end

  test "should get sleep_apnea_didgeridoo for logged out user" do
    get :sleep_apnea_didgeridoo
    assert_response :success
  end

  test "should get accepted_research_topics_index for experienced user" do
    login(@experienced_user)
    get :accepted_research_topics_index
    assert_response :success
  end

  test "should get sleep_apnea_body_weight for experienced user" do
    login(@experienced_user)
    get :sleep_apnea_body_weight
    assert_response :success
  end

  test "should get sleep_apnea_brain_plasticity for experienced user" do
    login(@experienced_user)
    get :sleep_apnea_brain_plasticity
    assert_response :success
  end

  test "should get sleep_apnea_adenotonsillectomy_children for experienced user" do
    login(@experienced_user)
    get :sleep_apnea_adenotonsillectomy_children
    assert_response :success
  end

  test "should get sleep_apnea_diabetes for experienced user" do
    login(@experienced_user)
    get :sleep_apnea_diabetes
    assert_response :success
  end

  test "should get sleep_apnea_nighttime_oxygen_use for experienced user" do
    login(@experienced_user)
    get :sleep_apnea_nighttime_oxygen_use
    assert_response :success
  end

  test "should get sleep_apnea_didgeridoo for experienced user" do
    login(@experienced_user)
    get :sleep_apnea_didgeridoo
    assert_response :success
  end

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

  # Intro : page explaining rank the research and allowing user to press "get started"
  test "should get intro and redirect for logged out user" do
    get :intro
    assert_redirected_to research_topics_path
  end

  test "should get intro for no_votes user" do
    login(@no_votes_user)
    get :intro
    assert_response :success
  end

  # First Topics - first 10 topics
  test "should get first topics and redirect for logged out user" do
    get :first_topics
    assert_redirected_to research_topics_path
  end

  test "should get first topics for novice user" do
    login(@novice_user)
    ResearchTopic.load_seeds
    get :first_topics
    assert_response :success
  end

  test "should get first topics for no_votes user that read the intro" do
    login(@no_votes_user)
    ResearchTopic.load_seeds
    get :first_topics, read_intro: 1
    assert_response :success
  end

  test "should redirect no_votes user to intro if they haven't read the intro" do
    login(@no_votes_user)
    get :first_topics
    assert_redirected_to intro_research_topics_path
  end

  test "should redirect from first topics to index for experienced users" do
    login(@experienced_user)
    get :first_topics
    assert_redirected_to research_topics_path
  end


  # Newest - index of newest topic pages
  test "should get newest for logged out user" do
    get :newest
    assert_response :success
  end

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
  test "should get most discussed for logged out user" do
    get :most_discussed
    assert_response :success
  end

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


  # Show pages
  test "should get show page as experienced user" do
    login(@experienced_user)
    get :show, id: @rt
    assert_response :success
  end

  test "should get show page as logged out user" do
    get :show, id: @rt
    assert_response :success
  end

  test "should not get new as logged out user" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get new as experienced user" do
    login(@experienced_user)
    get :new
    assert_response :success
  end

  test "should get edit as experienced user" do
    login(@experienced_user)
    get :edit, id: @rt
    assert_response :success
  end

  test "should update research topic as experienced user" do
    login(@experienced_user)
    patch :update, id: @rt, research_topic: { progress: 'accepted' }

    assert_not_nil assigns(:research_topic)
    assert_equal 'accepted', assigns(:research_topic).progress
    assert_template 'show'
    assert_response :success
  end

  test "should destroy research topic as experienced user" do
    login(@experienced_user)
    assert_difference('ResearchTopic.current.count', -1) do
      delete :destroy, id: @rt
    end

    assert_redirected_to research_topics_path
  end

  # Creation
  test "should create a research topic as experienced user" do
    login(@experienced_user)
    assert_difference('ResearchTopic.count') do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important'}
    end
    assert_redirected_to research_topic_path(ResearchTopic.last)
  end

  test "should not create a research topic with blank text" do
    login(@experienced_user)
    assert_difference('ResearchTopic.count', 0) do
      post :create, research_topic: { text: '', description: 'Why I think this is important'}
    end
    assert_not_nil assigns(:new_research_topic)
    assert_not_nil assigns(:research_topics)
    assert assigns(:new_research_topic).errors.size > 0
    assert_equal ["can't be blank"], assigns(:new_research_topic).errors[:text]
    assert_template 'index'
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


  # My Topics
  test "should get my topics for experienced user" do
    # Displays normal index
    login(@experienced_user)
    get :my_research_topics
    assert_not_nil assigns(:research_topics)
    assert_response :success
  end

  test "should get my topics and redirect to intro action for no_votes user" do
    login(@no_votes_user)
    get :my_research_topics
    assert_redirected_to intro_research_topics_path
  end

  test "should get my topics and redirect to first_topics action for novice_user" do
    login(@novice_user)
    get :my_research_topics
    assert_redirected_to first_topics_research_topics_path
  end

  test "should get my topics and redirect to index for logged out user" do
    get :my_research_topics
    assert_redirected_to research_topics_path
  end


  # Endorsement
  # Test w/ and w/o comment
  test "should endorse any approved research topic as experienced user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'

    login(@experienced_user)
    assert_nil research_topics(:rt2).endorsement

    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, "endorse_#{research_topics(:rt2).id}" => 1, format: 'js'
    end
    assert_equal 1.0, research_topics(:rt2).endorsement
    assert_not_nil assigns(:research_topic)
    assert_response :success
  end

  test "should add comment when voting for topic" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'

    login(@experienced_user)
    comment = "Hi there i'm commenting"

    assert_difference "Post.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, "endorse_#{research_topics(:rt2).id}" => 1, "comment_#{research_topics(:rt2).id}" => comment, format: 'js'
    end
    assert_equal comment, research_topics(:rt2).topic.posts.last.description
  end

  test "should vote for only the seeded research topics as a no_votes user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'

    login(@no_votes_user)
    ResearchTopic.load_seeds
    rt = ResearchTopic.where(category: "seeded").first

    assert_no_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, "endorse_#{research_topics(:rt2).id}" => 1, format: 'js'
    end
    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: rt.id, "endorse_#{rt.id}" => 1, format: 'js'
    end

  end


  test "should vote for only the seeded research topics as a novice user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'

    login(@novice_user)
    ResearchTopic.load_seeds
    rt = ResearchTopic.where(category: "seeded").first

    assert_no_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, "endorse_#{research_topics(:rt2).id}" => 1, format: 'js'
    end
    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: rt.id, "endorse_#{rt.id}" => 1, format: 'js'
    end
  end


  # Opposition
  test "should oppose any approved research topic as experienced user" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'

    login(@experienced_user)

    assert_nil research_topics(:rt2).endorsement
    assert_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, "endorse_#{research_topics(:rt2).id}" => 0, format: 'js'
    end
    assert_equal 0.0, research_topics(:rt2).endorsement
    assert_not_nil assigns(:research_topic)
    assert_response :success
  end

  # Invalid votes
  test "should not accept votes with no endorsement or opposition chosen" do
    @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'
    login(@experienced_user)

    assert_no_difference "Vote.count" do
      xhr :post, :vote, research_topic_id: research_topics(:rt2).id, format: 'js'
    end
  end


end
