require 'test_helper'

class ResearchTopicsControllerTest < ActionController::TestCase

  setup do
    @regular_user = users(:user_1)
    @moderator = users(:moderator_1)
  end


  # Voting
  test "User can endorse a research topic" do

  end

  # Others

  test "should get index for regular user" do
    login(@regular_user)
    get :index
    assert_not_nil assigns(:research_topics)
    assert_response :success
  end

  test "should create a research topic as regular user" do
    login(@regular_user)
    assert_difference('ResearchTopic.count') do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important', state: 'approved' }
    end
    assert_not_nil assigns(:research_topic)
    assert_equal 'under_review', assigns(:research_topic).state
    assert_redirected_to research_topics_path
  end

  test "should not create research topic as logged out user" do
    assert_difference('ResearchTopic.count', 0) do
      post :create, research_topic: { text: 'Some new research topic', description: 'Why I think this is important', state: 'approved' }
    end
    assert_nil assigns(:research_topic)
    assert_redirected_to new_user_session_path
  end

  # Older tests

  test "User can view accepted research topic" do
    login(users(:user_1))

    get :show, id: research_topics(:rt2).id

    assert_not_nil assigns(:research_topic)
    assert_response :success
  end

  test "User can update own research topic" do
    login(users(:user_2))

    new_attrs = {text: "Updated text"}

    assert users(:user_2).can_update?(research_topics(:rt2))

    patch :update, research_topic: new_attrs, id: research_topics(:rt2).id

    research_topics(:rt2).reload

    assert_equal research_topics(:rt2), assigns(:research_topic)
    assert_equal research_topics(:rt2).text, new_attrs[:text]

    assert_redirected_to research_topic_path(assigns(:research_topic))


  end

  test "User cannot modify another user's research topic" do
    login(users(:user_1))

    old_text = research_topics(:rt2).text
    new_attrs = {text: "Updated text"}

    assert_not_equal old_text, new_attrs[:text]

    patch :update, research_topic: new_attrs, id: research_topics(:rt2).id

    research_topics(:rt2).reload

    assert_equal research_topics(:rt2).text, old_text

    assert_authorization_exception
  end

  test "User cannot change state of research topic" do
    login(users(:social))

    new_attrs = {state: "accepted"}

    patch :update, research_topic: new_attrs, id: research_topics(:rejected).id

    research_topics(:rejected).reload

    assert_equal research_topics(:rejected).state, "rejected"
  end

  test "User can view un-accepted research topic that they own" do
    login(users(:social))

    get :show, id: research_topics(:rejected).id

    assert_response :success
    assert_equal research_topics(:rejected), assigns(:research_topic)


  end

  test "User cannot view un-accepted research topic that they do not own" do

    login(users(:user_1))

    get :show, id: research_topics(:rejected).id


    assert_authorization_exception
  end

  test "Moderator can change state of a research topic" do
    login(users(:moderator_1))

    new_attrs = {state: "accepted"}

    patch :update, research_topic: new_attrs, id: research_topics(:rejected).id

    research_topics(:rejected).reload

    assert_equal research_topics(:rejected).state, new_attrs[:state]
  end

end
