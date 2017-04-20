# frozen_string_literal: true

require 'test_helper'

# Tests to assure that member profiles can be viewed.
class MembersControllerTest < ActionController::TestCase
  test 'should get index and redirect to forums' do
    get :index
    assert_redirected_to topics_path
  end

  test 'should get show' do
    skip
    get :show, params: { forum_name: 'TomHaverford' }
    assert_response :success
  end

  test 'should not show without member' do
    skip
    get :show, params: { forum_name: 'DNE' }
    assert_redirected_to members_path
  end

  test 'should get posts' do
    get :posts, params: { forum_name: 'TomHaverford' }
    assert_response :success
  end

  test 'should get badges' do
    get :badges, params: { forum_name: 'TomHaverford' }
    assert_response :success
  end

  test 'should get photo' do
    get :photo, params: { forum_name: 'User1' }
    assert_response :success
  end
end
