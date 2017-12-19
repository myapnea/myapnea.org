# frozen_string_literal: true

require "test_helper"

# Test research and survey pages.
class SliceControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @moderator = users(:moderator_1)
    @regular_user = users(:user_1)
  end

  test "should get research" do
    get slice_research_url
    assert_response :success
  end

  test "should get surveys as regular user" do
    login(@regular_user)
    get slice_surveys_url
    assert_response :success
  end

  test "should get surveys and redirect as public user" do
    get slice_surveys_url
    assert_redirected_to slice_research_url
  end
end
