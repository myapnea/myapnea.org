# frozen_string_literal: true

require 'test_helper'

class InvitesControllerTest < ActionController::TestCase

  setup do
    @valid_user = users(:user_1)
  end

  test "should get members for logged in user" do
    login(@valid_user)
    get :members
    assert_response :success
  end

  test "should not get members for logged out user" do
    get :members
    assert_response :redirect
  end

  test "should get providers for logged in user" do
    login(@valid_user)
    get :providers
    assert_response :success
  end

  test "should not get providers for logged out user" do
    get :providers
    assert_response :redirect
  end

  test "should create invite for new member" do
    login(@valid_user)
    assert_difference('Invite.count') do
      post :create, invite: { email: 'test@test.com', for_provider: false }
    end

    assert_redirected_to members_invites_path
  end

  test "should create invite for existing member" do
    login(@valid_user)
    assert_difference('Invite.count') do
      post :create, invite: { email: @valid_user.email, for_provider: false }
    end

    assert_redirected_to members_invites_path
  end

  test "should create invite for provider" do
    login(@valid_user)
    assert_difference('Invite.count') do
      post :create, invite: { email: 'test@test.com', for_provider: true }
    end

    assert_redirected_to providers_invites_path
  end



end
