require 'test_helper'

class ReactionsControllerTest < ActionController::TestCase
  test "should add reaction for user" do
    login(users(:social))
    assert_difference "Reaction.count" do
      xhr :post, :create, reaction: { post_id: posts(:two), form: 'like' }, format: 'js'
    end
  end

  test "should not add reaction for logged out user" do
    assert_no_difference "Reaction.count" do
      xhr :post, :create, reaction: { post_id: posts(:two), form: 'like' }, format: 'js'
    end
  end

  test "should destroy reaction for user" do
    login(users(:social))
    assert_difference "Reaction.current.count", -1 do
      xhr :delete, :destroy, id: reactions(:one), format: 'js'
    end
  end

  test "should not destroy reaction for logged out user" do
    assert_no_difference "Reaction.current.count" do
      xhr :delete, :destroy, id: reactions(:one), format: 'js'
    end
  end
end
