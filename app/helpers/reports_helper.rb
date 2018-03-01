# frozen_string_literal: true

# Computes scores for MyApnea core summary report.
module ReportsHelper
  def report_insomnia(data)
    insoms = []
    insoms << data.dig("data", "is_falling_asleep")
    insoms << data.dig("data", "is_falling_asleep_3")
    insoms << data.dig("data", "is_wake_several_times")
    insoms << data.dig("data", "is_wake_several_times_3")
    insoms << data.dig("data", "is_wake_earlier")
    insoms << data.dig("data", "is_wake_earlier_3")
    insoms << data.dig("data", "is_trouble_back_sleep")
    insoms << data.dig("data", "is_trouble_back_sleep_3")
    insoms << data.dig("data", "is_overall_sleep_quality")
    return if insoms.count(&:blank?).positive?
    insoms.sum(&:to_i) * 1000
  end

  def report_fosq(data)
    fosqs = []
    fosqs << data.dig("data", "fosq_concentrating")
    fosqs << data.dig("data", "fosq_remembering")
    fosqs << data.dig("data", "fosq_operating_motor_less100")
    fosqs << data.dig("data", "fosq_operating_motor_greater100")
    fosqs << data.dig("data", "fosq_visiting")
    fosqs << data.dig("data", "fosq_relationships")
    fosqs << data.dig("data", "fosq_watching_movie")
    fosqs << data.dig("data", "fosq_active_evening")
    fosqs << data.dig("data", "fosq_active_morning")
    fosqs << data.dig("data", "fosq_desire")
    return if fosqs.count(&:blank?).positive?
    fosqs.sum(&:to_i) * 5 / fosqs.count
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
    whos = []
    whos << data.dig("data", "who_cheerful")
    whos << data.dig("data", "who_calm")
    whos << data.dig("data", "who_active")
    whos << data.dig("data", "who_fresh")
    whos << data.dig("data", "who_things_interest_me")
    return if whos.count(&:blank?).positive?
    whos.sum(&:to_i) * 4
  end

  def report_bmi(data)
    height = data.dig("data", "dem_height")
    weight = data.dig("data", "dem_weight")
    return unless weight.is_a?(Numeric) && height.is_a?(Numeric) && height.positive?
    weight * 703 / (height * height)
  end
end
