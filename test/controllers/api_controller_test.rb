require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get research topic index" do
    get :research_topic_index, format: :json
    assert_response :success
  end

  test "should get votes" do
    get :votes, format: :json
    assert_response :success
  end
end
