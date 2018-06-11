# frozen_string_literal: true

require "test_helper"

# Tests to assure that search results are returned.
class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_url
    assert_response :success
  end
end
