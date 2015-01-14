require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  test "Moderator can create a new notification" do
    login(users(:moderator_1))

    assert_difference "Notification.count" do
      post :create, notification: {title: "Some title", author: "Some author", body: "Body"}
    end

  end

  test "Non-moderator cannot create a new notification" do
    login(users(:user_1))

    refute_difference "Notification.count" do
      post :create, notification: {title: "Some title", author: "Some author", body: "Body"}
    end

  end

  test "Moderator can delete notification" do
    login(users(:moderator_1))

    assert_difference "Notification.current.count", -1 do
      delete :destroy, id: notifications(:accepted_blog_post).id
    end
  end

  test "Moderator can update notification" do
    login(users(:moderator_2))

    new_attrs = {title: "New title", state: "accepted" }
    patch :update, notification: new_attrs, id: notifications(:draft_blog_post).id

    notifications(:draft_blog_post).reload
    assert_equal new_attrs[:state], notifications(:draft_blog_post).state
    assert_equal new_attrs[:title], notifications(:draft_blog_post).title
  end

  test "Non-moderator cannot update notification" do
    login(users(:user_2))

    new_attrs = {title: "New title", state: "accepted" }
    patch :update, notification: new_attrs, id: notifications(:draft_blog_post).id

    notifications(:draft_blog_post).reload
    assert_not_equal new_attrs[:state], notifications(:draft_blog_post).state
    assert_not_equal new_attrs[:title], notifications(:draft_blog_post).title

  end

  test "Non-moderator cannot delete notification" do
    login(users(:user_1))

    refute_difference "Notification.count", -1 do
      delete :destroy, id: notifications(:accepted_blog_post).id
    end

  end

end
