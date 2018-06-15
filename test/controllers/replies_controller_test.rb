# frozen_string_literal: true

require "test_helper"

# Tests to assure that community members can comment on blog posts.
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

  # test "should get index" do
  #   login(@regular)
  #   get :index, topic_id: @reply.topic.to_param
  #   assert_response :success
  # end

  # test "should get new" do
  #   login(@regular)
  #   get :new, topic_id: @reply.topic.to_param
  #   assert_response :success
  # end

  test "should preview reply" do
    login(@regular)
    post preview_replies_url(format: "js"), params: {
      parent_reply_id: "root", reply_id: "new", reply: reply_params
    }
    assert_response :success
  end

  test "should create reply" do
    login(@regular)
    assert_difference("Reply.count") do
      post replies_url(format: "js"), params: {
        topic_id: @reply.topic.to_param, reply: reply_params
      }
    end
    @regular.reload
    assert_nil @regular.shadow_banned
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

  test "should show reply and redirect to correct page" do
    login(@regular)
    get reply_url(@reply), params: { topic_id: @reply.topic.to_param }
    assert_redirected_to page_topic_url(@reply.topic, page: @reply.page, anchor: @reply.anchor)
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

  test "should destroy reply" do
    login(@regular)
    assert_difference("Reply.current.count", -1) do
      delete reply_url(@reply, format: "js"), params: { topic_id: @reply.topic.to_param }
    end
    assert_response :success
  end
end
