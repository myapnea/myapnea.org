require 'test_helper'

class ResearchTopicsControllerTest < ActionController::TestCase

  setup do
    @no_votes_user = users(:user_1)
    @novice_user = users(:user_1)
    @experienced_user = users(:user_1)

    @moderator = users(:moderator_1)
  end

  # Index

  test "should get index for experienced user" do
    # Displays normal index
    login(@regular_user)
    get :index
    assert_not_nil assigns(:research_topics)
    assert_response :success
  end

  test "should redirect to intro action for no_votes user" do

  end

  test "should redirect to first_topics action for novice_user" do

  end


  # Intro

  test "should get intro for no_votes user" do
    # page explaining rank the research and allowing user to press "get started"


  end


  # First Topics
  test "should get first topics for novice user" do

  end

  test "should get first topics for no_votes user that read the intro" do

  end

  test "should redirect no_votes user to intro if they haven't read the intro" do

  end

  test "should redirect to index for experienced users" do

  end

  # Newest
  test "should get newest for experienced user" do

  end

  test "should redirect to intro action for no_votes user" do

  end

  test "should redirect to first_topics action for novice_user" do

  end

  # Most Discussed
  test "should get most_discussed for experienced user" do

  end

  test "should redirect to intro action for no_votes user" do

  end

  test "should redirect to first_topics action for novice_user" do

  end


  # Creation

  test "should create a research topic as experienced user" do
    login(@regular_user)
    assert_difference('ResearchTopic.count') do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important', state: 'approved' }
    end
    assert_not_nil assigns(:research_topic)
    assert_equal 'under_review', assigns(:research_topic).state
    assert_redirected_to research_topics_path
  end

  test "should not create research topic as novice user" do

  end

  test "should not create research topic as no votes user" do

  end

  test "should not create research topic as logged out user" do
    assert_difference('ResearchTopic.count', 0) do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important', state: 'approved' }
    end
    assert_nil assigns(:research_topic)
    assert_redirected_to new_user_session_path
  end


  # Endorsement
  # Test w/ and w/o comment

  test "should endorse any approved research topic as experienced user" do
    login(@regular_user)

    assert_difference "ResearchTopic.find_by_id(#{research_topics(:rt2).id}).rating" do
      assert_difference "Vote.count" do
        xhr :post, :vote, vote: { research_topic_id: research_topics(:rt2).id, rating: '1' }, format: 'js'
      end
    end

    assert_not_nil assigns(:research_topic)
    assert_not_nil assigns(:vote)

    assert_template 'vote'
    assert_response :success

  end

  test "should endorse only the seeded research topics as a novice or no_votes user" do

  end

  # Opposition

  # Mirror image of Endorsement



end
