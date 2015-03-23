module ToolsHelper

  def bmi(height, weight)
    (weight/height**2 * 703).round
  end

  def bmi_category(bmi)
    if bmi < 18.5
      "Underweight"
    elsif bmi < 25
      "Normal"
    elsif bmi < 30
      "Overweight"
    else
      "Obese"
    end
  end
end

