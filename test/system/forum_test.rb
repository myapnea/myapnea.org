# frozen_string_literal: true

require "application_system_test_case"

# System tests for forum.
class ForumTest < ApplicationSystemTestCase
  test "visit forum" do
    visit topics_url
    screenshot("visit-forum")
    # scroll_down
    # screenshot("visit-forum")
  end

  test "visit forum topic" do
    visit topic_url(topics(:one))
    screenshot("visit-forum-topic")
  end
end
