# frozen_string_literal: true

require 'test_helper'

# Tests to assure that users can react to posts.
class ReactionsControllerTest < ActionController::TestCase
  test 'should add reaction for user' do
    login(users(:social))
    assert_difference 'Reaction.count' do
      post :create, params: { reaction: { post_id: posts(:two).id, form: 'like' } }, format: 'js'
    end
  end

  test 'should not add reaction for logged out user' do
    assert_no_difference 'Reaction.count' do
      post :create, params: { reaction: { post_id: posts(:two).id, form: 'like' } }, format: 'js'
    end
  end

  test 'should destroy reaction for user' do
    login(users(:social))
    assert_difference 'Reaction.current.count', -1 do
      delete :destroy, params: { id: reactions(:one) }, format: 'js'
    end
  end

  test 'should not destroy reaction for logged out user' do
    assert_no_difference 'Reaction.current.count' do
      delete :destroy, params: { id: reactions(:one) }, format: 'js'
    end
  end
end
