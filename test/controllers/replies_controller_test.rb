# frozen_string_literal: true

require "test_helper"

# Tests to assure that members can reply to blog posts and forum topics.
class RepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reply = replies(:one)
    @regular = users(:regular)
  end

  def reply_params
    {
      description: @reply.description,
      reply_id: nil
    }
  end

  test "should preview reply" do
    login(@regular)
    post preview_replies_url(format: "js"), params: {
      parent_reply_id: "root", reply_id: "new", reply: reply_params
    }
    assert_response :success
  end

  test "should create reply to forum topic" do
    login(@regular)
    assert_difference("Reply.count") do
      post replies_url(format: "js"), params: {
        topic_id: topics(:one).to_param, reply: reply_params
      }
    end
    assert_response :success
  end

  test "should create reply to blog post" do
    login(@regular)
    assert_difference("Reply.count") do
      post replies_url(format: "js"), params: {
        broadcast_id: broadcasts(:published).to_param, reply: reply_params
      }
    end
    assert_response :success
  end

  test "should shadow ban new spammer after creating reply" do
    login(@regular)
    assert_difference("Reply.count") do
      post replies_url(format: "js"), params: {
        topic_id: @reply.topic.to_param,
        reply: reply_params.merge(description: "http://www.example.com\nhttp://www.example.com")
      }
    end
    @regular.reload
    assert_equal true, @regular.shadow_banned
    assert_response :success
  end

  test "should not create reply on locked forum topic" do
    login(@regular)
    assert_difference("Reply.count", 0) do
      post replies_url(format: "js"), params: {
        topic_id: topics(:locked).to_param, reply: reply_params
      }
    end
    assert_response :success
  end

  test "should not create reply on auto-locked forum topic" do
    login(@regular)
    assert_difference("Reply.count", 0) do
      post replies_url(format: "js"), params: {
        topic_id: topics(:auto_locked).to_param, reply: reply_params
      }
    end
    assert_response :success
  end

  test "should show reply to a forum topic and redirect to correct page" do
    login(@regular)
    get reply_url(@reply)
    assert_redirected_to page_topic_url(@reply.topic, page: @reply.page, anchor: @reply.anchor)
  end

  test "should show reply to a blog post and redirect to correct page" do
    login(@regular)
    get reply_url(replies(:blog_one))
    assert_redirected_to blog_post_url(
      broadcasts(:published).url_hash.merge(page: replies(:blog_one).page, anchor: replies(:blog_one).anchor)
    )
  end

  test "should show reply" do
    login(@regular)
    get reply_url(@reply, format: "js"), params: { topic_id: @reply.topic.to_param }, xhr: true
    assert_response :success
  end

  test "should redirect to root path for deleted replies" do
    get reply_url(replies(:deleted))
    assert_redirected_to root_url
  end

  test "should get edit" do
    login(@regular)
    get edit_reply_url(@reply, format: "js"), params: {
      topic_id: @reply.topic.to_param
    }, xhr: true
    assert_response :success
  end

  test "should update reply" do
    login(@regular)
    patch reply_url(@reply, format: "js"), params: {
      topic_id: @reply.topic.to_param, reply: reply_params
    }
    @regular.reload
    assert_nil @regular.shadow_banned
    assert_response :success
  end

  test "should update reply and shadow ban spammer" do
    login(@regular)
    patch reply_url(@reply, format: "js"), params: {
      topic_id: @reply.topic.to_param,
      reply: reply_params.merge(description: "http://www.example.com\nhttp://www.example.com")
    }
    @regular.reload
    assert_equal true, @regular.shadow_banned
    assert_response :success
  end

  test "should update reply on locked topic" do
    login(@regular)
    patch reply_url(replies(:auto_locked), format: "js"), params: { reply: reply_params }
    assert_response :success
  end

  test "should destroy reply" do
    login(@regular)
    assert_difference("Reply.current.count", -1) do
      delete reply_url(@reply, format: "js"), params: { topic_id: @reply.topic.to_param }
    end
    assert_response :success
  end
end
