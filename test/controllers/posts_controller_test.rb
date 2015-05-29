require "test_helper"

class PostsControllerTest < ActionController::TestCase

  setup do
    @owner = users(:owner)
    @moderator = users(:moderator_1)
    @valid_user = users(:user_1)
    @post = posts(:one)
    @topic = topics(:one)
    @forum = forums(:one)
  end

  test "should get show and redirect to specific page and location on topic" do
    login(users(:user_2))
    get :show, forum_id: posts(:six).forum, topic_id: posts(:six).topic, id: posts(:six)

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_redirected_to forum_topic_path(assigns(:forum), assigns(:topic)) + "?page=1#c2"
  end

  test "should get post preview" do
    login(users(:user_2))
    assert_difference('Post.count', 0) do
      xhr :post, :preview, forum_id: @forum, topic_id: @topic, post: { description: "This is my contribution to the discussion." }
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_template 'preview'
    assert_response :success
  end

  test "should not get post preview as logged out user" do
    assert_difference('Post.count', 0) do
      xhr :post, :preview, forum_id: @forum, topic_id: @topic, post: { description: "This is my contribution to the discussion." }
    end

    assert_nil assigns(:forum)
    assert_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_response 401
  end

  test "should create post and not update existing subscription" do
    login(users(:user_2))
    assert_difference('Post.count') do
      post :create, forum_id: @forum, topic_id: @topic, post: { description: "This is my contribution to the discussion." }
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_equal "This is my contribution to the discussion.", assigns(:topic).posts.last.description
    assert_not_nil assigns(:topic).last_post_at
    assert_equal false, assigns(:topic).subscribed?(users(:user_2))

    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should create pending_review post as regular user" do
    login(users(:user_1))
    assert_difference('Post.count') do
      post :create, forum_id: @forum, topic_id: @topic, post: { description: "I'm trying to approve my own post.", status: 'approved' }
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_equal 'pending_review', assigns(:post).status
    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should create approved post as moderator" do
    login(users(:moderator_1))
    assert_difference('Post.count') do
      post :create, forum_id: @forum, topic_id: @topic, post: { description: "I'm trying to approve my own post.", status: 'approved' }
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_equal 'approved', assigns(:post).status
    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should create post and add subscription" do
    login(users(:moderator_1))

    assert_difference('Post.count') do
      post :create, forum_id: @forum, topic_id: @topic, post: { description: "With this post I'm subscribing to the discussion." }
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_equal "With this post I'm subscribing to the discussion.", assigns(:topic).posts.last.description
    assert_not_nil assigns(:topic).last_post_at
    assert_equal true, assigns(:topic).subscribed?(users(:moderator_1))

    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should create post and mark new last post at" do
    login(users(:moderator_1))

    assert_difference('Post.count') do
      post :create, forum_id: @forum, topic_id: @topic, post: { description: "This post", status: 'approved' }
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_equal assigns(:post).created_at.strftime("%-m/%-d/%Y at %-l:%M %p"), assigns(:post).topic.last_post_at.strftime("%-m/%-d/%Y at %-l:%M %p")

    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should not create post as logged out user" do
    assert_difference('Post.count', 0) do
      post :create, forum_id: @forum, topic_id: @topic, post: { description: "I'm not logged in." }
    end

    assert_redirected_to new_user_session_path
  end

  # test "should not create post as banned user" do
  #   login(users(:banned))
  #   assert_difference('Post.count', 0) do
  #     post :create, topic_id: @topic, post: { description: "I'm banned from creating posts." }
  #   end

  #   assert_not_nil assigns(:topic)
  #   assert_nil assigns(:post)

  #   assert_redirected_to assigns(:topic)
  # end

  test "should not create post on locked topic" do
    login(@valid_user)
    assert_difference('Post.count', 0) do
      post :create, forum_id: topics(:locked).forum, topic_id: topics(:locked), post: { description: "Adding a post to a locked topic." }
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_redirected_to forum_topic_path(assigns(:forum), assigns(:topic))
  end

  test "should get edit" do
    login(@valid_user)
    xhr :get, :edit, forum_id: @forum, topic_id: @topic, id: @post, format: 'js'

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_template 'edit'
    assert_response :success
  end

  test "should not get edit for post on locked topic" do
    login(@valid_user)
    xhr :get, :edit, forum_id: @forum, topic_id: topics(:locked), id: posts(:three), format: 'js'

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_response :success
  end

  test "should not get edit as another user" do
    login(users(:user_2))
    xhr :get, :edit, forum_id: @forum, topic_id: @topic, id: @post, format: 'js'

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_response :success
  end

  # test "should not get edit as banned user" do
  #   login(users(:banned))
  #   xhr :get, :edit, topic_id: posts(:banned).topic, id: posts(:banned), format: 'js'

  #   assert_not_nil assigns(:topic)
  #   assert_nil assigns(:post)

  #   assert_response :success
  # end

  test "should update post" do
    login(@valid_user)
    patch :update, forum_id: @forum, topic_id: @topic, id: @post, post: { description: "Updated Description" }

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal "Updated Description", assigns(:post).description

    assert_equal true, assigns(:topic).subscribed?(@valid_user)

    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should update post but not reset subscription" do
    login(users(:user_2))
    patch :update, forum_id: posts(:six).forum, topic_id: posts(:six).topic, id: posts(:six), post: { description: "Updated Description" }

    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)
    assert_equal "Updated Description", assigns(:post).description

    assert_equal false, assigns(:topic).subscribed?(users(:user_2))

    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should not update post on locked topic" do
    login(@valid_user)
    patch :update, forum_id: topics(:locked).forum, topic_id: topics(:locked), id: posts(:three), post: { description: "Updated Description on Locked" }

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_redirected_to forum_topic_path(assigns(:forum), assigns(:topic))
  end

  # test "should not update post as banned user" do
  #   login(users(:banned))
  #   patch :update, topic_id: posts(:banned).topic, id: posts(:banned), post: { description: "I was banned so I'm changing my post" }

  #   assert_not_nil assigns(:topic)
  #   assert_nil assigns(:post)

  #   assert_redirected_to assigns(:topic)
  # end

  test "should not update as another user" do
    login(users(:user_2))
    patch :update, forum_id: @forum, topic_id: @topic, id: @post, post: { description: "Updated Description" }

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_redirected_to forum_topic_path(assigns(:forum), assigns(:topic))
  end

  test "should destroy post as owner" do
    login(@owner)
    assert_difference('Post.current.count', -1) do
      delete :destroy, forum_id: @forum, topic_id: @topic, id: @post
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should destroy post as post author" do
    login(@valid_user)
    assert_difference('Post.current.count', -1) do
      delete :destroy, forum_id: @forum, topic_id: @topic, id: @post
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_not_nil assigns(:post)

    assert_redirected_to forum_topic_post_path(assigns(:forum), assigns(:topic), assigns(:post))
  end

  test "should not destroy post as moderator" do
    login(@moderator)
    assert_difference('Post.current.count', 0) do
      delete :destroy, forum_id: @forum, topic_id: @topic, id: @post
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_redirected_to forum_topic_path(assigns(:forum), assigns(:topic))
  end

  test "should not destroy post as another user" do
    login(users(:user_2))
    assert_difference('Post.current.count', 0) do
      delete :destroy, forum_id: @forum, topic_id: @topic, id: @post
    end

    assert_not_nil assigns(:forum)
    assert_not_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_redirected_to forum_topic_path(assigns(:forum), assigns(:topic))
  end

  test "should not destroy post as logged out user" do
    assert_difference('Post.current.count', 0) do
      delete :destroy, forum_id: @forum, topic_id: @topic, id: @post
    end

    assert_nil assigns(:forum)
    assert_nil assigns(:topic)
    assert_nil assigns(:post)

    assert_redirected_to new_user_session_path
  end

end
