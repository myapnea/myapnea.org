# frozen_string_literal: true

require "test_helper"

# Tests to assure that tools calculate as intended.
class ToolsHelperTest < ActionView::TestCase
  test "should calculate bmi" do
    assert_equal 22, bmi("70", "150").round
    assert_equal "Underweight", bmi_category(18)
    assert_equal "Normal weight", bmi_category(22)
    assert_equal "Overweight", bmi_category(25)
    assert_equal "Obese", bmi_category(30)
  end
end
