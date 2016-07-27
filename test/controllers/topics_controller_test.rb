# frozen_string_literal: true

require 'test_helper'

# Tests to assure that forum topics can be view and created.
class TopicsControllerTest < ActionController::TestCase
  setup do
    @owner = users(:owner)
    @moderator = users(:moderator_1)
    @valid_user = users(:user_1)
    @another_user = users(:user_3)
    @topic = topics(:one)
  end

  test 'should get forum index' do
    get :index
    assert_redirected_to chapters_path
  end

  test 'should not get new for logged out user' do
    get :new
    assert_redirected_to new_user_session_path
  end

  test 'should get new for valid user' do
    login(@valid_user)
    get :new
    assert_response :success
  end

  test 'should get new for moderator' do
    login(@moderator)
    get :new
    assert_response :success
  end

  test 'should not create topic for logged out user' do
    assert_difference('Post.count', 0) do
      assert_difference('Topic.count', 0) do
        post :create, params: { topic: { name: 'New Topic Name', description: 'First Post on New Topic' } }
      end
    end
    assert_redirected_to new_user_session_path
  end

  test 'should create topic for valid user' do
    login(@valid_user)
    assert_difference('Post.count') do
      assert_difference('Topic.count') do
        post :create, params: { topic: { name: 'New Topic Name', description: 'First Post on New Topic', status: 'hidden' } }
      end
    end
    assert_not_nil assigns(:topic)
    assert_equal 'New Topic Name', assigns(:topic).name
    assert_equal @valid_user, assigns(:topic).user
    assert_equal 'pending_review', assigns(:topic).status
    assert_equal 'First Post on New Topic', assigns(:topic).posts.first.description
    assert_equal @valid_user, assigns(:topic).posts.first.user
    assert_nil assigns(:topic).last_post_at
    assert_equal true, assigns(:topic).subscribed?(@valid_user)
    assert_redirected_to assigns(:topic)
  end

  test 'should create topic with valid slug when starting title with a number' do
    login(@valid_user)
    assert_difference('Post.count') do
      assert_difference('Topic.count') do
        post :create, params: { topic: { name: '12', description: 'A topic post about the number twelve.' } }
      end
    end
    assert_not_nil assigns(:topic)
    assert_equal '12', assigns(:topic).name
    assert_equal 't12', assigns(:topic).slug.first(3)
    assert_equal @valid_user, assigns(:topic).user
    assert_equal 'A topic post about the number twelve.', assigns(:topic).posts.first.description
    assert_equal @valid_user, assigns(:topic).posts.first.user
    assert_nil assigns(:topic).last_post_at
    assert_redirected_to assigns(:topic)
  end

  test 'should create topic and rewrite slug for topic slugs that would default to new' do
    login(@valid_user)

    assert_difference('Post.count') do
      assert_difference('Topic.count') do
        post :create, params: { topic: { name: 'New', description: 'A new topic.' } }
      end
    end
    assert_not_nil assigns(:topic)
    assert assigns(:topic).valid?
    refute_equal 'new', assigns(:topic).slug
    assert_redirected_to assigns(:topic)
  end

  test 'should unsubscribe for valid user' do
    login(@valid_user)
    assert_equal true, @topic.subscribed?(@valid_user)
    post :subscription, params: { id: @topic, notify: '0' }, format: 'js'
    assert_not_nil assigns(:topic)
    assert_equal false, assigns(:topic).subscribed?(@valid_user)
    assert_template 'subscription'
    assert_response :success
  end

  test 'should subscribe for another user' do
    login(@another_user)
    assert_equal false, @topic.subscribed?(@another_user)
    post :subscription, params: { id: @topic, notify: '1' }, format: 'js'
    assert_not_nil assigns(:topic)
    assert_equal true, assigns(:topic).subscribed?(@another_user)
    assert_template 'subscription'
    assert_response :success
  end

  test 'should show topic and increase views count' do
    get :show, params: { id: @topic }
    assert_not_nil assigns(:topic)
    assert_equal 2, assigns(:topic).views_count
    assert_response :success
  end

  test 'should show topic for logged out user' do
    get :show, params: { id: @topic }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should show topic for valid user' do
    login(@valid_user)
    get :show, params: { id: @topic }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should show topic for moderator' do
    login(@moderator)
    get :show, params: { id: @topic }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should not show topic marked as spam for logged out user' do
    get :show, params: { id: topics(:spam) }
    assert_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should not show topic marked as spam for valid user' do
    login(@valid_user)
    get :show, params: { id: topics(:spam) }
    assert_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should show topic marked as spam for moderator' do
    login(@moderator)
    get :show, params: { id: topics(:spam) }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should not show hidden topic for logged out user' do
    get :show, params: { id: topics(:hidden) }
    assert_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should not show hidden topic for valid user' do
    login(users(:user_2))
    get :show, params: { id: topics(:hidden) }
    assert_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should show pending review topic for topic creator' do
    login(@valid_user)
    get :show, params: { id: topics(:two) }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should show hidden topic for moderator' do
    login(@moderator)
    get :show, params: { id: topics(:hidden) }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should not get edit for logged out user' do
    get :edit, params: { id: topics(:one) }
    assert_redirected_to new_user_session_path
  end

  test 'should not get edit for user who did not create topic' do
    login(users(:user_1))
    get :edit, params: { id: topics(:one) }
    assert_redirected_to topics_path
  end

  test 'should get edit for topic creator' do
    login(users(:user_1))
    get :edit, params: { id: topics(:two) }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should get edit for forum moderator' do
    login(@moderator)
    get :edit, params: { id: @topic }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test 'should not update topic for logged out user' do
    put :update, params: { id: @topic, topic: { name: 'Updated Topic Name' } }
    assert_nil assigns(:topic)
    assert_redirected_to new_user_session_path
  end

  test 'should not update topic for user who did not create topic' do
    login(@valid_user)
    put :update, params: { id: topics(:one), topic: { name: 'Updated Topic Name' } }
    assert_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should update topic for topic creator' do
    login(@valid_user)
    put :update, params: { id: topics(:two), topic: { name: 'Updated Topic Name' } }
    assert_not_nil assigns(:topic)
    assert_equal 'Updated Topic Name', assigns(:topic).name
    assert_redirected_to assigns(:topic)
  end

  test 'should update topic for forum moderator' do
    login(@moderator)
    put :update, params: { id: @topic, topic: { name: 'Updated Topic Name' } }
    assert_not_nil assigns(:topic)
    assert_equal 'Updated Topic Name', assigns(:topic).name
    assert_redirected_to assigns(:topic)
  end

  test 'should not destroy topic for logged out user' do
    assert_difference('Topic.current.count', 0) do
      delete :destroy, params: { id: @topic }
    end
    assert_nil assigns(:topic)
    assert_redirected_to new_user_session_path
  end

  test 'should not destroy topic for user who did not create topic' do
    login(@valid_user)
    assert_difference('Topic.current.count', 0) do
      delete :destroy, params: { id: topics(:one) }
    end
    assert_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should destroy topic for topic creator' do
    login(@valid_user)
    assert_difference('Topic.current.count', -1) do
      delete :destroy, params: { id: topics(:two) }
    end
    assert_not_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should destroy topic for owner' do
    login(@owner)
    assert_difference('Topic.current.count', -1) do
      delete :destroy, params: { id: @topic }
    end
    assert_not_nil assigns(:topic)
    assert_redirected_to topics_path
  end

  test 'should not destroy topic for moderator' do
    login(@moderator)
    assert_difference('Topic.current.count', 0) do
      delete :destroy, params: { id: topics(:one) }
    end
    assert_nil assigns(:topic)
    assert_redirected_to topics_path
  end
end
