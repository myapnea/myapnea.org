require "test_helper"

class ToolsControllerTest < ActionController::TestCase
  def test_risk_assessment
    get :risk_assessment
    assert_response :success
  end

  test "should get risk assessment results" do
    post :risk_assessment_results
    assert_response :success
  end

end
