require 'test_helper'

class Admin::TeamMembersControllerTest < ActionController::TestCase
  setup do
    @admin = users(:owner)
    @admin_team_member = admin_team_members(:one)
  end

  test 'should get photo for logged out user' do
    get :photo, id: @admin_team_member
    assert_response :success
  end

  test "should get index" do
    login(@admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_team_members)
  end

  test "should get new" do
    login(@admin)
    get :new
    assert_response :success
  end

  test "should create admin_team_member" do
    login(@admin)
    assert_difference('Admin::TeamMember.count') do
      post :create, admin_team_member: { bio: @admin_team_member.bio, designations: @admin_team_member.designations, name: @admin_team_member.name, photo: @admin_team_member.photo, position: @admin_team_member.position, role: @admin_team_member.role }
    end

    assert_redirected_to admin_team_member_path(assigns(:admin_team_member))
  end

  test "should show admin_team_member" do
    login(@admin)
    get :show, id: @admin_team_member
    assert_redirected_to admin_team_members_path
  end

  test "should get edit" do
    login(@admin)
    get :edit, id: @admin_team_member
    assert_response :success
  end

  test "should update admin_team_member" do
    login(@admin)
    patch :update, id: @admin_team_member, admin_team_member: { bio: @admin_team_member.bio, designations: @admin_team_member.designations, name: @admin_team_member.name, photo: @admin_team_member.photo, position: @admin_team_member.position, role: @admin_team_member.role }
    assert_redirected_to admin_team_member_path(assigns(:admin_team_member))
  end

  test "should destroy admin_team_member" do
    login(@admin)
    assert_difference('Admin::TeamMember.current.count', -1) do
      delete :destroy, id: @admin_team_member
    end

    assert_redirected_to admin_team_members_path
  end
end
