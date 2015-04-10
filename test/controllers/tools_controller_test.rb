require "test_helper"

class ToolsControllerTest < ActionController::TestCase
  def test_risk_assessment
    get :risk_assessment
    assert_response :success
  end

  test "should get risk assessment results" do
    get :risk_assessment_results
    assert_redirected_to sleep_apnea_risk_assessment_results_path(category: 1, score: 0)
  end

end
