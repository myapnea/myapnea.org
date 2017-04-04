# frozen_string_literal: true

require 'test_helper'

# Tests to assure that users can create replies to blog posts and forum topics
class Async::ParentControllerTest < ActionController::TestCase
  setup do
    @regular_user = users(:user_1)
  end

  test 'should start new reply on blog post for public user' do
    post :reply, params: {
      broadcast_id: broadcasts(:published).to_param,
      parent_reply_id: 'root', reply_id: 'new'
    }, format: 'js'
    assert_not_nil assigns(:reply)
    assert_equal true, assigns(:reply).new_record?
    assert_equal Broadcast, assigns(:reply).parent.class
    assert_template 'reply'
    assert_response :success
  end

  test 'should start new reply on forum topic for public user' do
    post :reply, params: {
      chapter_id: chapters(:one).to_param,
      parent_reply_id: 'root', reply_id: 'new'
    }, format: 'js'
    assert_not_nil assigns(:reply)
    assert_equal true, assigns(:reply).new_record?
    assert_equal Chapter, assigns(:reply).parent.class
    assert_template 'reply'
    assert_response :success
  end

  test 'should start new reply on blog post for regular user' do
    login(@regular_user)
    post :reply, params: {
      broadcast_id: broadcasts(:published).to_param,
      parent_reply_id: 'root', reply_id: 'new'
    }, format: 'js'
    assert_template 'reply'
    assert_response :success
  end

  test 'should start new reply on forum topic for regular user' do
    login(@regular_user)
    post :reply, params: {
      chapter_id: chapters(:one).to_param, parent_reply_id: 'root', reply_id: 'new'
    }, format: 'js'
    assert_template 'reply'
    assert_response :success
  end

  test 'should sign in as user when replying to blog post' do
    post :login, params: {
      email: 'user_1@example.com', password: 'password',
      broadcast_id: broadcasts(:published).to_param
    }, format: 'js'
    assert_not_nil assigns(:reply)
    assert_equal true, assigns(:reply).new_record?
    assert_equal Broadcast, assigns(:reply).parent.class
    assert_template 'create'
    assert_response :success
  end

  test 'should sign in as user when replying to forum topic' do
    post :login, params: {
      email: 'user_1@example.com', password: 'password',
      chapter_id: chapters(:one).to_param
    }, format: 'js'
    assert_not_nil assigns(:reply)
    assert_equal true, assigns(:reply).new_record?
    assert_equal Chapter, assigns(:reply).parent.class
    assert_template 'create'
    assert_response :success
  end

  test 'should not sign in as user with incorrect password when reply to blog post' do
    post :login, params: {
      email: 'user_1@example.com', password: 'wrong',
      broadcast_id: broadcasts(:published).to_param
    }, format: 'js'
    assert_template 'new'
    assert_response :success
  end

  test 'should not sign in as user with incorrect password when reply to forum topic' do
    post :login, params: {
      email: 'user_1@example.com', password: 'wrong',
      chapter_id: chapters(:one).to_param
    }, format: 'js'
    assert_template 'new'
    assert_response :success
  end
end
