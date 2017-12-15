# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure admin can view reports.
class AdminControllerTest < ActionController::TestCase
  setup do
    @admin = users(:admin)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  test 'should get dashboard as admin' do
    login(@admin)
    get :dashboard
    assert_response :success
  end

  test 'should get dashboard as moderator' do
    login(@moderator)
    get :dashboard
    assert_response :success
  end

  test 'should not get dashboard as regular user' do
    login(@regular_user)
    get :dashboard
    assert_equal flash[:alert], 'You do not have sufficient privileges to access that page.'
    assert_redirected_to root_path
  end

  test 'should not get dashboard as logged out user' do
    get :dashboard
    assert_redirected_to new_user_session_path
  end

  test "should get spam inbox as admin" do
    login(@admin)
    get :spam_inbox
    assert_response :success
  end

  test "should empty spam as admin" do
    login(@admin)
    post :empty_spam
    assert_equal 0, User.current.where(shadow_banned: true).count
    assert_equal 0, Topic.current.where(user: User.current.where(shadow_banned: true)).count
    assert_redirected_to admin_spam_inbox_path
  end

  test "should unspamban user as admin" do
    login(@admin)
    assert_difference("User.where(spammer: nil).count", -1) do
      post :unspamban, params: { id: users(:shadow_banned).id }
    end
    assert_equal "Member marked as not a spammer. You may still need to unshadow ban them.", flash[:notice]
    assert_redirected_to admin_spam_inbox_path
  end
end
