# frozen_string_literal: true

require 'test_helper'

# Tests to assure that community members can create and view forum topics.
class ChaptersControllerTest < ActionController::TestCase
  setup do
    @chapter = chapters(:one)
    @regular_user = users(:user_1)
  end

  def chapter_params
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
    assert_not_nil assigns(:chapters)
  end

  test 'should get new' do
    login(@regular_user)
    get :new
    assert_response :success
  end

  test 'should create chapter' do
    login(@regular_user)
    assert_difference('Chapter.count') do
      post :create, params: { chapter: chapter_params }
    end
    assert_not_nil assigns(:chapter)
    assert_equal 'Topic Title', assigns(:chapter).title
    assert_equal 'This is the my new forum topic.', assigns(:chapter).replies.first.description
    assert_equal users(:user_1), assigns(:chapter).user
    assert_redirected_to assigns(:chapter)
  end

  test 'should not create chapter with blank title' do
    login(@regular_user)
    assert_difference('Chapter.count', 0) do
      post :create, params: { chapter: chapter_params.merge(title: '') }
    end
    assert_template 'new'
    assert_response :success
  end

  test 'should shadow ban new spammer' do
    login(users(:new_spammer))
    assert_difference('Chapter.count') do
      post :create, params: { chapter: { title: 'http://www.example.com', slug: 'http-www-example-com', description: 'http://www.example.com' } }
    end
    assert_equal true, assigns(:chapter).user.shadow_banned
    assert_redirected_to assigns(:chapter)
  end

  test 'should not shadow ban verified user' do
    login(users(:verified_user))
    assert_difference('Chapter.count') do
      post :create, params: { chapter: { title: 'http://www.example.com', slug: 'http-www-example-com', description: 'http://www.example.com' } }
    end
    assert_equal false, assigns(:chapter).user.shadow_banned
    assert_redirected_to assigns(:chapter)
  end

  # test 'should not create chapter for shadow banned user' do
  #   login(users(:shadow_banned))
  #   assert_difference('Chapter.count', 0) do
  #     post :create, params: { chapter: chapter_params.merge(title: '') }
  #   end
  #   assert_redirected_to chapters_path
  # end

  test 'should show chapter' do
    login(@regular_user)
    get :show, params: { id: @chapter }
    assert_response :success
  end

  test 'should get edit' do
    login(@regular_user)
    get :edit, params: { id: @chapter }
    assert_response :success
  end

  test 'should update chapter' do
    login(@regular_user)
    patch :update, params: { id: @chapter, chapter: chapter_params }
    assert_redirected_to assigns(:chapter)
  end

  test 'should not update chapter with blank title' do
    login(@regular_user)
    patch :update, params: { id: @chapter, chapter: chapter_params.merge(title: '') }
    assert_template 'edit'
    assert_response :success
  end

  test 'should destroy chapter' do
    login(@regular_user)
    assert_difference('Chapter.current.count', -1) do
      delete :destroy, params: { id: @chapter }
    end
    assert_redirected_to chapters_path
  end
end
