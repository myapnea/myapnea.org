module ToolsHelper

  def bmi(height, weight)
    (weight.to_f/(height.to_f**2) * 703)
  end

  def bmi_category(bmi)
    if bmi < 18.5
      "Underweight"
    elsif bmi < 25
      "Normal weight"
    elsif bmi < 30
      "Overweight"
    else
      "Obese"
    end
  end
end

