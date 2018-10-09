# frozen_string_literal: true

require "test_helper"

# Test to assure users are recruited to external projects.
class ParticipateControllerTest < ActionDispatch::IntegrationTest
  setup do
    @regular = users(:regular)
    @project = projects(:external)
  end

  test "should recruit user to external project" do
    login(@regular)
    assert_difference("Subject.count") do
      get participate_url(@project)
    end
    assert_redirected_to @project.external_link
  end
end
