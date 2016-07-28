# frozen_string_literal: true

require 'test_helper'

# Tests to assure that users can view and modify forum posts.
class PostsControllerTest < ActionController::TestCase
  setup do
    @owner = users(:owner)
    @moderator = users(:moderator_1)
    @valid_user = users(:user_1)
    @post = posts(:one)
    @topic = topics(:one)
  end

  test 'should get index and redirect to topic' do
    get :index, params: { topic_id: posts(:six).topic, id: posts(:six) }
    assert_not_nil assigns(:topic)
    assert_redirected_to assigns(:topic)
  end

  test 'should get show and redirect to specific page and location on topic' do
    login(users(:user_2))
    get :show, params: { topic_id: posts(:six).topic, id: posts(:six) }
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_redirected_to topic_path(assigns(:topic), page: 1, anchor: 'c2')
  end

  test 'should get post preview' do
    login(users(:user_2))
    assert_difference('Post.count', 0) do
      post :preview, params: { topic_id: @topic, post: { description: 'This is my contribution to the discussion.' } }, format: 'js'
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_template 'preview'
    assert_response :success
  end

  test 'should not get post preview as logged out user' do
    assert_difference('Post.count', 0) do
      post :preview, params: { topic_id: @topic, post: { description: 'This is my contribution to the discussion.' } }, format: 'js'
    end
    assert_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_response :unauthorized
  end

  test 'should create post and not update existing subscription' do
    login(users(:user_2))
    assert_difference('Post.count') do
      post :create, params: { topic_id: @topic, post: { description: 'This is my contribution to the discussion.' } }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal 'This is my contribution to the discussion.', assigns(:topic).posts.last.description
    assert_not_nil assigns(:topic).last_post_at
    assert_equal false, assigns(:topic).subscribed?(users(:user_2))
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should create pending_review post as regular user' do
    login(users(:user_1))
    assert_difference('Post.count') do
      post :create, params: { topic_id: @topic, post: { description: 'I am trying to approve my own post.', status: 'approved' } }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal 'pending_review', assigns(:post).status
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should create approved post as moderator' do
    login(users(:moderator_1))
    assert_difference('Post.count') do
      post :create, params: { topic_id: @topic, post: { description: 'I am trying to approve my own post.', status: 'approved' } }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal 'approved', assigns(:post).status
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should create post and add subscription' do
    login(users(:moderator_1))
    assert_difference('Post.count') do
      post :create, params: { topic_id: @topic, post: { description: 'With this post I am subscribing to the discussion.' } }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal 'With this post I am subscribing to the discussion.', assigns(:topic).posts.last.description
    assert_not_nil assigns(:topic).last_post_at
    assert_equal true, assigns(:topic).subscribed?(users(:moderator_1))
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should not create post with blank description' do
    login(users(:user_1))
    assert_difference('Post.count', 0) do
      post :create, params: { topic_id: @topic, post: { description: '' } }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert assigns(:post).errors.size > 0
    assert_equal ["can't be blank"], assigns(:post).errors[:description]
    assert_redirected_to assigns(:topic)
  end

  test 'should create post and mark new last post at' do
    login(users(:moderator_1))
    assert_difference('Post.count') do
      post :create, params: { topic_id: @topic, post: { description: 'This post', status: 'approved' } }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    @topic.reload
    assert_equal assigns(:post).created_at.strftime('%-m/%-d/%Y at %-l:%M %p'), @topic.last_post_at.strftime('%-m/%-d/%Y at %-l:%M %p')
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should not create post as logged out user' do
    assert_difference('Post.count', 0) do
      post :create, params: { topic_id: @topic, post: { description: 'I am not logged in.' } }
    end
    assert_redirected_to new_user_session_path
  end

  # test 'should not create post as banned user' do
  #   login(users(:banned))
  #   assert_difference('Post.count', 0) do
  #     post :create, params: { topic_id: @topic, post: { description: 'I am banned from creating posts.' } }
  #   end
  #   assert_not_nil assigns(:topic)
  #   assert_nil assigns(:post)
  #   assert_redirected_to assigns(:topic)
  # end

  test 'should not create post on locked topic' do
    login(@valid_user)
    assert_difference('Post.count', 0) do
      post :create, params: { topic_id: topics(:locked), post: { description: 'Adding a post to a locked topic.' } }
    end
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_redirected_to assigns(:topic)
  end

  test 'should get edit' do
    login(@valid_user)
    get :edit, params: { topic_id: @topic, id: @post }, xhr: true, format: 'js'
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_template 'edit'
    assert_response :success
  end

  test 'should not get edit for post on locked topic' do
    login(@valid_user)
    get :edit, params: { topic_id: topics(:locked), id: posts(:three) }, xhr: true, format: 'js'
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_response :success
  end

  test 'should not get edit as another user' do
    login(users(:user_2))
    get :edit, params: { topic_id: @topic, id: @post }, xhr: true, format: 'js'
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_response :success
  end

  # test 'should not get edit as banned user' do
  #   login(users(:banned))
  #   get :edit, params: { topic_id: posts(:banned).topic, id: posts(:banned) }, xhr: true, format: 'js'
  #   assert_not_nil assigns(:topic)
  #   assert_nil assigns(:post)
  #   assert_response :success
  # end

  test 'should update post' do
    login(@valid_user)
    patch :update, params: { topic_id: @topic, id: @post, post: { description: 'Updated Description' } }
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal 'Updated Description', assigns(:post).description
    assert_equal true, assigns(:topic).subscribed?(@valid_user)
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should update post but not reset subscription' do
    login(users(:user_2))
    patch :update, params: { topic_id: posts(:six).topic, id: posts(:six), post: { description: 'Updated Description' } }
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal 'Updated Description', assigns(:post).description
    assert_equal false, assigns(:topic).subscribed?(users(:user_2))
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should not update post on locked topic' do
    login(@valid_user)
    patch :update, params: { topic_id: topics(:locked), id: posts(:three), post: { description: 'Updated Description on Locked' } }
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_redirected_to assigns(:topic)
  end

  test 'should not update post with blank description' do
    login(@valid_user)
    patch :update, params: { topic_id: @topic, id: @post, post: { description: '' } }
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert assigns(:post).errors.size > 0
    assert_equal ["can't be blank"], assigns(:post).errors[:description]
    assert_template 'edit'
    assert_response :success
  end

  # test 'should not update post as banned user' do
  #   login(users(:banned))
  #   patch :update, params: { topic_id: posts(:banned).topic, id: posts(:banned), post: { description: 'I was banned so I am changing my post' } }
  #   assert_not_nil assigns(:topic)
  #   assert_nil assigns(:post)
  #   assert_redirected_to assigns(:topic)
  # end

  test 'should not update as another user' do
    login(users(:user_2))
    patch :update, params: { topic_id: @topic, id: @post, post: { description: 'Updated Description' } }
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_redirected_to assigns(:topic)
  end

  test 'should destroy post as owner' do
    login(@owner)
    assert_difference('Post.current.count', -1) do
      delete :destroy, params: { topic_id: @topic, id: @post }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal @owner, assigns(:post).deleted_by
    assert_equal 'approved', assigns(:post).status
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should destroy post as post author' do
    login(@valid_user)
    assert_difference('Post.current.count', -1) do
      delete :destroy, params: { topic_id: @topic, id: posts(:pending_review) }
    end
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal @valid_user, assigns(:post).deleted_by
    assert_equal 'hidden', assigns(:post).status
    assert_redirected_to [assigns(:topic), assigns(:post)]
  end

  test 'should not destroy post as moderator' do
    login(@moderator)
    assert_difference('Post.current.count', 0) do
      delete :destroy, params: { topic_id: @topic, id: @post }
    end
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_redirected_to assigns(:topic)
  end

  test 'should not destroy post as another user' do
    login(users(:user_2))
    assert_difference('Post.current.count', 0) do
      delete :destroy, params: { topic_id: @topic, id: @post }
    end
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_redirected_to assigns(:topic)
  end

  test 'should not destroy post as logged out user' do
    assert_difference('Post.current.count', 0) do
      delete :destroy, params: { topic_id: @topic, id: @post }
    end
    assert_nil assigns(:topic)
    assert_nil assigns(:post)
    assert_redirected_to new_user_session_path
  end
end
