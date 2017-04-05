# frozen_string_literal: true

require 'test_helper'

# Tests to assure that community members can create and view forum topics.
class TopicsControllerTest < ActionController::TestCase
  setup do
    @topic = topics(:one)
    @regular_user = users(:user_1)
  end

  def topic_params
    {
      title: 'Topic Title',
      slug: 'topic-title',
      description: 'This is the my new forum topic.',
      pinned: '1'
    }
  end

  test 'should get index' do
    login(@regular_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:topics)
  end

  test 'should get new' do
    login(@regular_user)
    get :new
    assert_response :success
  end

  test 'should create topic' do
    login(@regular_user)
    assert_difference('Topic.count') do
      post :create, params: { topic: topic_params }
    end
    assert_not_nil assigns(:topic)
    assert_equal 'Topic Title', assigns(:topic).title
    assert_equal 'This is the my new forum topic.', assigns(:topic).replies.first.description
    assert_equal users(:user_1), assigns(:topic).user
    assert_redirected_to assigns(:topic)
  end

  test 'should not create topic with blank title' do
    login(@regular_user)
    assert_difference('Topic.count', 0) do
      post :create, params: { topic: topic_params.merge(title: '') }
    end
    assert_template 'new'
    assert_response :success
  end

  test 'should shadow ban new spammer' do
    login(users(:new_spammer))
    assert_difference('Topic.count') do
      post :create, params: { topic: { title: 'http://www.example.com', slug: 'http-www-example-com', description: 'http://www.example.com' } }
    end
    assert_equal true, assigns(:topic).user.shadow_banned
    assert_redirected_to assigns(:topic)
  end

  test 'should not shadow ban verified user' do
    login(users(:verified_user))
    assert_difference('Topic.count') do
      post :create, params: { topic: { title: 'http://www.example.com', slug: 'http-www-example-com', description: 'http://www.example.com' } }
    end
    assert_equal false, assigns(:topic).user.shadow_banned
    assert_redirected_to assigns(:topic)
  end

  # test 'should not create topic for shadow banned user' do
  #   login(users(:shadow_banned))
  #   assert_difference('Topic.count', 0) do
  #     post :create, params: { topic: topic_params.merge(title: '') }
  #   end
  #   assert_redirected_to topics_path
  # end

  test 'should show topic' do
    login(@regular_user)
    get :show, params: { id: @topic }
    assert_response :success
  end

  test 'should get edit' do
    login(@regular_user)
    get :edit, params: { id: @topic }
    assert_response :success
  end

  test 'should update topic' do
    login(@regular_user)
    patch :update, params: { id: @topic, topic: topic_params }
    assert_redirected_to assigns(:topic)
  end

  test 'should not update topic with blank title' do
    login(@regular_user)
    patch :update, params: { id: @topic, topic: topic_params.merge(title: '') }
    assert_template 'edit'
    assert_response :success
  end

  test 'should destroy topic' do
    login(@regular_user)
    assert_difference('Topic.current.count', -1) do
      delete :destroy, params: { id: @topic }
    end
    assert_redirected_to topics_path
  end
end
