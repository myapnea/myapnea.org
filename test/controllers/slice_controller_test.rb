# frozen_string_literal: true

require "test_helper"

# Test research and survey pages.
class SliceControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @moderator = users(:moderator)
    @regular = users(:regular)
  end

  test "should redirect surveys to research" do
    get surveys_url
    assert_redirected_to slice_research_url
  end

  test "should get external research page" do
    get slice_research_url
    assert_response :success
  end

  test "should get internal research as regular user" do
    login(@regular)
    get slice_research_url
    assert_response :success
  end
end
