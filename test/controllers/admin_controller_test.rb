# frozen_string_literal: true

require "test_helper.rb"

# Tests to assure admin can view reports.
class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @moderator = users(:moderator)
    @regular = users(:regular)
  end

  test "should get dashboard as admin" do
    login(@admin)
    get admin_url
    assert_response :success
  end

  test "should get dashboard as moderator" do
    login(@moderator)
    get admin_url
    assert_response :success
  end

  test "should not get dashboard as regular user" do
    login(@regular)
    get admin_url
    assert_redirected_to root_url
  end

  test "should not get dashboard as logged out user" do
    get admin_url
    assert_redirected_to new_user_session_url
  end

  test "should get spam report as admin" do
    login(@admin)
    get admin_spam_report_url
    assert_response :success
  end

  test "should get spam inbox as admin" do
    login(@admin)
    get admin_spam_inbox_url
    assert_response :success
  end

  test "should empty spam as admin" do
    login(@admin)
    post admin_empty_spam_url
    assert_equal 0, User.current.where(shadow_banned: true).count
    assert_equal 0, Topic.current.where(user: User.current.where(shadow_banned: true)).count
    assert_redirected_to admin_spam_inbox_url
  end

  test "should destroy spammer as admin" do
    login(@admin)
    assert_difference("User.where(spammer: true).count") do
      post admin_destroy_spammer_url(users(:shadow_banned), format: "js")
    end
    assert_template "destroy_spammer"
    assert_response :success
  end

  test "should unspamban user as admin" do
    login(@admin)
    assert_difference("User.where(spammer: nil).count", -1) do
      post admin_unspamban_url(users(:shadow_banned))
    end
    assert_equal "Member marked as not a spammer. You may still need to unshadow ban them.", flash[:notice]
    assert_redirected_to admin_spam_inbox_url
  end

  test "should get profile review as admin" do
    login(@admin)
    get admin_profile_review_url
    assert_response :success
  end

  test "should approve profile as admin" do
    login(@admin)
    assert_difference("User.where(profile_reviewed: true).count") do
      post admin_submit_profile_review_url(user_id: users(:user_1), approved: "1")
    end
    assert_redirected_to admin_profile_review_url
  end

  test "should remove spammer profile as admin" do
    login(@admin)
    assert_difference("User.where(spammer: true).count") do
      post admin_submit_profile_review_url(user_id: users(:new_spammer), spammer: "1")
    end
    assert_redirected_to admin_profile_review_url
  end
end
