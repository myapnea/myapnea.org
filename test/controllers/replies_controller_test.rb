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
    post :preview, parent_comment_id: 'root', reply_id: 'new', reply: reply_params, format: 'js'
    assert_template 'preview'
    assert_response :success
  end

  test 'should create reply' do
    login(@regular_user)
    assert_difference('Reply.count') do
      post :create, chapter_id: @reply.chapter.to_param, reply: reply_params, format: 'js'
    end
    assert_template 'create'
    assert_response :success
  end

  test 'should show reply' do
    login(@regular_user)
    xhr :get, :show, chapter_id: @reply.chapter.to_param, id: @reply, format: 'js'
    assert_template 'show'
    assert_response :success
  end

  test 'should get edit' do
    login(@regular_user)
    xhr :get, :edit, chapter_id: @reply.chapter.to_param, id: @reply, format: 'js'
    assert_template 'edit'
    assert_response :success
  end

  test 'should update reply' do
    login(@regular_user)
    patch :update, chapter_id: @reply.chapter.to_param, id: @reply, reply: reply_params, format: 'js'
    assert_template 'show'
    assert_response :success
  end

  test 'should destroy reply' do
    login(@regular_user)
    assert_difference('Reply.current.count', -1) do
      delete :destroy, chapter_id: @reply.chapter.to_param, id: @reply, format: 'js'
    end
    assert_template 'show'
    assert_response :success
  end
end
