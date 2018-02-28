# frozen_string_literal: true

# Computes scores for MyApnea core summary report.
module ReportsHelper
  def report_insomnia(data)
  end

  def report_fosq(data)
  end

  def report_ess(data)
    e1 = data.dig("data", "ess_sitting_reading")
    e2 = data.dig("data", "ess_sitting_reading")
    e3 = data.dig("data", "ess_watching_tv")
    e4 = data.dig("data", "ess_public_place")
    e5 = data.dig("data", "ess_car_passenger")
    e6 = data.dig("data", "ess_lying_down_rest")
    e7 = data.dig("data", "ess_sitting_talking")
    e8 = data.dig("data", "ess_after_lunch")
    e9 = data.dig("data", "ess_traffic")
    return if e1.blank? || e2.blank? || e3.blank? || e4.blank? || e5.blank? || e6.blank? || e7.blank? || e8.blank? || e9.blank?
    e1.to_i + e2.to_i + e3.to_i + e4.to_i + e5.to_i + e6.to_i + e7.to_i + e8.to_i + e9.to_i
  end

  def report_well_being(data)
  end

  def report_bmi(data)
    height = data.dig("data", "dem_tall")
    weight = data.dig("data", "dem_weight")
    return unless weight.is_a?(Numeric) && height.is_a?(Numeric) && height.positive?
    weight * 703 / (height * height)
  end
end
