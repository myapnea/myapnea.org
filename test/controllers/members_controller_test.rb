# frozen_string_literal: true

require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  # test 'should get index' do
  #   get :index
  #   assert_response :success
  # end

  test 'should get index and redirect to forums' do
    get :index
    assert_redirected_to forums_path
  end

  test 'should get show' do
    get :show, forum_name: 'TomHaverford'
    assert_response :success
  end

  test 'should not show without member' do
    get :show, forum_name: 'DNE'
    assert_redirected_to members_path
  end

  test 'should get search' do
    get :search, q: 'Tom', format: 'json'
    members_json = JSON.parse(response.body)
    assert_includes members_json, 'TomHaverford'
    assert_response :success
  end
end
