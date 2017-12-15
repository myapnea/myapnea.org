# frozen_string_literal: true

require "test_helper"

# Tests to assure that member profiles can be viewed.
class MembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index and redirect to forums" do
    get members_url
    assert_redirected_to topics_url
  end

  test "should get show" do
    get member_url("TomHaverford")
    assert_redirected_to posts_member_url("TomHaverford")
    # assert_response :success
  end

  test "should not show without member" do
    get member_url("DNE")
    assert_redirected_to members_url
  end

  test "should get posts" do
    get posts_member_url("TomHaverford")
    assert_response :success
  end

  test "should get badges" do
    get badges_member_url("TomHaverford")
    assert_response :success
  end

  test "should get member profile picture with username" do
    get profile_picture_member_url(users(:user_2).forum_name)
    assert_not_nil response
    assert_kind_of String, response.body
    assert_equal File.binread(users(:user_2).photo.path), response.body
  end
end
