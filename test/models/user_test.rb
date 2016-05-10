# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # test "should update location for user with valid ip" do
  #   skip # Should use artifice or something similar to fake a response
  #   Map.update_user_location(users(:social))
  #   assert_not_nil users(:social).country_code
  # end

  test "#my_research_topics" do
    assert_equal research_topics(:rt1), users(:user_1).my_research_topics.first
  end
end
