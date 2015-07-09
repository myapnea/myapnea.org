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

  # test "should cast vote for user" do
  #   post :vote, user_id: "1", research_topic_id: "1", endorse: "1"
  # end

end
