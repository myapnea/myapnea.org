# frozen_string_literal: true

require 'test_helper'

# Tests to assure that community members can comment on blog posts.
class RepliesControllerTest < ActionController::TestCase
  setup do
    @reply = replies(:one)
    @regular_user = users(:user_1)
  end

  def reply_params
    {
      description: @reply.description,
      reply_id: nil
    }
  end

  # test 'should get index' do
  #   login(@regular_user)
  #   get :index, chapter_id: @reply.chapter.to_param
  #   assert_response :success
  #   assert_not_nil assigns(:replies)
  # end

  # test 'should get new' do
  #   login(@regular_user)
  #   get :new, chapter_id: @reply.chapter.to_param
  #   assert_response :success
  # end

  test 'should preview reply' do
    login(@regular_user)
    post :preview, params: { parent_comment_id: 'root', reply_id: 'new', reply: reply_params }, format: 'js'
    assert_template 'preview'
    assert_response :success
  end

  test 'should create reply' do
    login(@regular_user)
    assert_difference('Reply.count') do
      post :create, params: { chapter_id: @reply.chapter.to_param, reply: reply_params }, format: 'js'
    end
    assert_nil assigns(:reply).user.shadow_banned
    assert_template 'create'
    assert_response :success
  end

  test 'should shadow ban new spammer after creating reply' do
    login(@regular_user)
    assert_difference('Reply.count') do
      post :create, params: {
        chapter_id: @reply.chapter.to_param,
        reply: reply_params.merge(description: "http://www.example.com\nhttp://www.example.com")
      }, format: 'js'
    end
    assert_equal true, assigns(:reply).user.shadow_banned
    assert_template 'create'
    assert_response :success
  end

  test 'should show reply and redirect to correct page' do
    login(@regular_user)
    get :show, params: { chapter_id: @reply.chapter.to_param, id: @reply }
    assert_redirected_to page_chapter_path(@reply.chapter, page: @reply.page, anchor: @reply.anchor)
  end

  test 'should show reply' do
    login(@regular_user)
    get :show, params: { chapter_id: @reply.chapter.to_param, id: @reply }, xhr: true, format: 'js'
    assert_template 'show'
    assert_response :success
  end

  test 'should redirect to forum for deleted replies' do
    get :show, params: { id: replies(:deleted) }
    assert_redirected_to chapters_path
  end

  test 'should get edit' do
    login(@regular_user)
    get :edit, params: { chapter_id: @reply.chapter.to_param, id: @reply }, xhr: true, format: 'js'
    assert_template 'edit'
    assert_response :success
  end

  test 'should update reply' do
    login(@regular_user)
    patch :update, params: { chapter_id: @reply.chapter.to_param, id: @reply, reply: reply_params }, format: 'js'
    assert_nil assigns(:reply).user.shadow_banned
    assert_template 'show'
    assert_response :success
  end

  test 'should update reply and shadow ban spammer' do
    login(@regular_user)
    patch :update, params: {
      chapter_id: @reply.chapter.to_param, id: @reply,
      reply: reply_params.merge(description: "http://www.example.com\nhttp://www.example.com")
    }, format: 'js'
    assert_equal true, assigns(:reply).user.shadow_banned
    assert_template 'show'
    assert_response :success
  end

  test 'should destroy reply' do
    login(@regular_user)
    assert_difference('Reply.current.count', -1) do
      delete :destroy, params: { chapter_id: @reply.chapter.to_param, id: @reply }, format: 'js'
    end
    assert_template 'show'
    assert_response :success
  end
end
