# frozen_string_literal: true

require 'test_helper'

# Tests to assure that comments can be added to posts.
class CommentsControllerTest < ActionController::TestCase
  test 'should add comment to post for user' do
    login(users(:social))
    assert_difference 'Comment.count' do
      xhr :post, :create, comment: { post_id: posts(:two).id, content: 'Great idea' }, format: 'js'
    end
  end

  test 'should not add comment for logged out user' do
    assert_no_difference 'Comment.count' do
      xhr :post, :create, comment: { post_id: posts(:two).id, content: 'Great idea' }, format: 'js'
    end
  end

  test 'should destroy comment for user' do
    login(users(:social))
    assert_difference 'Comment.current.count', -1 do
      xhr :delete, :destroy, id: comments(:one), format: 'js'
    end
  end

  test 'should not destroy comment for logged out user' do
    assert_no_difference 'Comment.current.count' do
      xhr :delete, :destroy, id: comments(:one), format: 'js'
    end
  end
end
