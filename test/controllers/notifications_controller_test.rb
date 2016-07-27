# frozen_string_literal: true

require 'test_helper'

# Test that notifications can be viewed and marked as read.
class NotificationsControllerTest < ActionController::TestCase
  test 'should get index' do
    login(users(:user_1))
    get :index
    assert_response :success
    assert_not_nil assigns(:notifications)
  end

  test 'should get all read index' do
    login(users(:user_1))
    get :index, params: { all: '1' }
    assert_response :success
    assert_not_nil assigns(:notifications)
  end

  test 'should show blog comment notification' do
    login(users(:user_1))
    get :show, params: { id: notifications(:broadcast_comment_two) }
    assert_not_nil assigns(:notification)
    assert_equal true, assigns(:notification).read
    assert_redirected_to blog_post_path(assigns(:notification).broadcast.url_hash.merge(anchor: "comment-#{broadcast_comments(:two).id}"))
  end

  test 'should show blank notification and redirect' do
    login(users(:user_1))
    get :show, params: { id: notifications(:blank) }
    assert_not_nil assigns(:notification)
    assert_equal true, assigns(:notification).read
    assert_redirected_to notifications_path
  end

  test 'should not show notification without valid id' do
    login(users(:user_1))
    get :show, params: { id: -1 }
    assert_nil assigns(:notification)
    assert_redirected_to notifications_path
  end

  test 'should update notification' do
    login(users(:user_1))
    patch :update, params: { id: notifications(:broadcast_comment_two), notification: { read: true } }, format: 'js'
    assert_not_nil assigns(:notification)
    assert_equal true, assigns(:notification).read
    assert_template 'show'
    assert_response :success
  end

  test 'should mark all as read' do
    login(users(:user_1))
    patch :mark_all_as_read, params: { broadcast_id: broadcasts(:published).id }, format: 'js'
    assert_equal 0, users(:user_1).notifications.where(broadcast_id: broadcasts(:published), read: false).count
    assert_template 'mark_all_as_read'
    assert_response :success
  end

  test 'should not mark all as read without broadcast' do
    login(users(:user_1))
    assert_difference('Notification.where(read: false).count', 0) do
      patch :mark_all_as_read, format: 'js'
    end
    assert_template 'mark_all_as_read'
    assert_response :success
  end
end
