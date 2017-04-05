# frozen_string_literal: true

require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  test 'should get index and redirect to forums' do
    get :index
    assert_redirected_to topics_path
  end

  test 'should get show' do
    get :show, params: { forum_name: 'TomHaverford' }
    assert_response :success
  end

  test 'should not show without member' do
    get :show, params: { forum_name: 'DNE' }
    assert_redirected_to members_path
  end
end
