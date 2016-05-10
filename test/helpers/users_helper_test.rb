# frozen_string_literal: true

require 'test_helper'

# Tests to assure that user helpers work
class UsersHelperTest < ActionView::TestCase
  test 'should generate user photo url' do
    assert_equal 'default-user.jpg', user_photo_url(users(:user_1))
  end
end
