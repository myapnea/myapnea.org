# frozen_string_literal: true

require 'test_helper'

# Test for publicly available pages.
class ExternalControllerTest < ActionController::TestCase
  setup do
    @regular_user = users(:user_1)
  end

  test 'should get community' do
    get :community
    assert_response :success
  end

  test 'should get contact' do
    get :contact
    assert_response :success
  end

  test 'should get consent' do
    get :consent
    assert_response :success
  end

  test 'should get landing' do
    get :landing
    assert_response :success
  end

  test 'should get landing for regular user' do
    login(@regular_user)
    get :landing
    assert_response :success
  end

  test 'should get privacy policy' do
    get :privacy
    assert_response :success
  end

  test 'should get terms and conditions' do
    get :terms_and_conditions
    assert_response :success
  end

  test 'should get terms and conditions for regular user' do
    login(@regular_user)
    get :terms_and_conditions
    assert_response :success
  end

  test 'should get terms of access' do
    get :terms_of_access
    assert_response :success
  end

  test 'should get voting' do
    get :voting
    assert_response :success
  end

  test 'should get version' do
    get :version
    assert_response :success
  end

  test 'should get version as json' do
    get :version, format: 'json'
    version = JSON.parse(response.body)
    assert_equal WwwMyapneaOrg::VERSION::STRING, version['version']['string']
    assert_equal WwwMyapneaOrg::VERSION::MAJOR, version['version']['major']
    assert_equal WwwMyapneaOrg::VERSION::MINOR, version['version']['minor']
    assert_equal WwwMyapneaOrg::VERSION::TINY, version['version']['tiny']
    if WwwMyapneaOrg::VERSION::BUILD.nil?
      assert_nil version['version']['build']
    else
      assert_equal WwwMyapneaOrg::VERSION::BUILD, version['version']['build']
    end
    assert_response :success
  end
end
