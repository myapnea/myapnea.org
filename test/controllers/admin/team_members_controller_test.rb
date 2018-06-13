# frozen_string_literal: true

require "test_helper"

# Test to make sure admins can manage team members.
class Admin::TeamMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @admin_team_member = admin_team_members(:one)
  end

  def admin_team_member_params
    {
      bio: @admin_team_member.bio,
      designations: @admin_team_member.designations,
      name: @admin_team_member.name,
      photo: @admin_team_member.photo,
      position: @admin_team_member.position,
      role: @admin_team_member.role
    }
  end

  test "should get order as admin" do
    login(@admin)
    get order_admin_team_members_url
    assert_response :success
  end

  test "should update order as admin" do
    login(@admin)
    post order_admin_team_members_url, params: {
      team_member_ids: [admin_team_members(:two).id, admin_team_members(:one).id]
    }
    admin_team_members(:one).reload
    admin_team_members(:two).reload
    assert_equal 0, admin_team_members(:two).position
    assert_equal 1, admin_team_members(:one).position
    assert_response :success
  end

  test "should get index" do
    login(@admin)
    get admin_team_members_url
    assert_response :success
  end

  test "should get new" do
    login(@admin)
    get new_admin_team_member_url
    assert_response :success
  end

  test "should create admin_team_member" do
    login(@admin)
    assert_difference("Admin::TeamMember.count") do
      post admin_team_members_url, params: {
        admin_team_member: admin_team_member_params
      }
    end
    assert_redirected_to admin_team_member_url(Admin::TeamMember.last)
  end

  test "should show admin_team_member" do
    login(@admin)
    get admin_team_member_url(@admin_team_member)
    assert_redirected_to admin_team_members_url
  end

  test "should get edit" do
    login(@admin)
    get edit_admin_team_member_url(@admin_team_member)
    assert_response :success
  end

  test "should update admin_team_member" do
    login(@admin)
    patch admin_team_member_url(@admin_team_member), params: {
      admin_team_member: admin_team_member_params
    }
    assert_redirected_to admin_team_member_url(@admin_team_member)
  end

  test "should destroy admin_team_member" do
    login(@admin)
    assert_difference("Admin::TeamMember.current.count", -1) do
      delete admin_team_member_url(@admin_team_member)
    end
    assert_redirected_to admin_team_members_url
  end
end
