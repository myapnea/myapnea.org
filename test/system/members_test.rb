# frozen_string_literal: true

require "application_system_test_case"

# System tests for member profiles.
class MembersTest < ApplicationSystemTestCase
  test "visit member profile" do
    visit posts_member_url(users(:user_1).username)
    screenshot("visit-member-profile")
    assert_selector "h1", text: "RubyGem"
  end
end
