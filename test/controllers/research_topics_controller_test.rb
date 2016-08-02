# frozen_string_literal: true

require 'test_helper'

# Tests to assure that members can create and vote on research topics.
class ResearchTopicsControllerTest < ActionController::TestCase
  setup do
    @no_votes_user = users(:user_2)
    @novice_user = users(:user_4)
    @experienced_user = users(:user_1)
    @rt = research_topics(:rt1)
    @rt2 = research_topics(:rt2)
  end

  # Index
  test 'should get index for logged out user' do
    get :index
    assert_response :success
  end

  test 'should get index for experienced user' do
    # Displays normal index
    login(@experienced_user)
    get :index
    assert_not_nil assigns(:research_topics)
    assert_response :success
  end

  # Intro : page explaining rank the research and allowing user to press 'get started'
  test 'should get intro and redirect for logged out user' do
    get :intro
    assert_redirected_to research_topics_path
  end

  test 'should get intro for no_votes user' do
    login(@no_votes_user)
    get :intro
    assert_response :success
  end

  # First Topics - first 10 topics
  test 'should get first topics and redirect for logged out user' do
    get :first_topics
    assert_redirected_to research_topics_path
  end

  # Show pages
  test 'should get show page as experienced user' do
    login(@experienced_user)
    get :show, params: { id: @rt }
    assert_response :success
  end

  test 'should get show page as moderator' do
    login(users(:moderator_1))
    get :show, params: { id: @rt }
    assert_response :success
  end

  test 'should get show page as logged out user' do
    get :show, params: { id: @rt }
    assert_response :success
  end

  test 'should not get new as logged out user' do
    get :new
    assert_redirected_to new_user_session_path
  end

  test 'should get new as experienced user' do
    login(@experienced_user)
    get :new
    assert_response :success
  end

  test 'should get edit as experienced user' do
    login(@experienced_user)
    get :edit, params: { id: @rt }
    assert_response :success
  end

  test 'should update research topic as experienced user' do
    login(@experienced_user)
    patch :update, params: { id: @rt, research_topic: { progress: 'accepted' } }
    assert_not_nil assigns(:research_topic)
    assert_equal 'accepted', assigns(:research_topic).progress
    assert_template 'show'
    assert_response :success
  end

  test 'should destroy research topic as experienced user' do
    login(@experienced_user)
    assert_difference('ResearchTopic.current.count', -1) do
      delete :destroy, params: { id: @rt }
    end
    assert_redirected_to research_topics_path
  end

  # Creation
  test 'should create a research topic as experienced user' do
    login(@experienced_user)
    assert_difference('ResearchTopic.count') do
      post :create, params: { research_topic: { text: 'Some new research topic', description: 'Why I think this is important' } }
    end
    assert_redirected_to research_topic_path(ResearchTopic.last)
  end

  test 'should not create a research topic with blank text' do
    login(@experienced_user)
    assert_difference('ResearchTopic.count', 0) do
      post :create, params: { research_topic: { text: '', description: 'Why I think this is important' } }
    end
    assert_not_nil assigns(:new_research_topic)
    assert_not_nil assigns(:research_topics)
    assert assigns(:new_research_topic).errors.size > 0
    assert_equal ["can't be blank"], assigns(:new_research_topic).errors[:text]
    assert_template 'index'
    assert_response :success
  end

  test 'should not create research topic as logged out user' do
    assert_no_difference('ResearchTopic.count') do
      post :create, params: { research_topic: { text: 'Some new research topic', description: 'Why I think this is important' } }
    end
  end

  # My Topics
  test 'should get my topics for experienced user' do
    # Displays normal index
    login(@experienced_user)
    get :my_research_topics
    assert_not_nil assigns(:research_topics)
    assert_response :success
  end

  test 'should get my topics and redirect to index for logged out user' do
    get :my_research_topics
    assert_redirected_to research_topics_path
  end
end
