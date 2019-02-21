# frozen_string_literal: true

# Computes scores for MyApnea summary report.
module Reportable
  extend ActiveSupport::Concern

  def report_insomnia(data)
    return if data.nil?
    insoms = []
    insoms << data.dig("data", "baseline", "is_falling_asleep")
    insoms << data.dig("data", "baseline", "is_wake_several_times")
    insoms << data.dig("data", "baseline", "is_wake_earlier")
    insoms << data.dig("data", "baseline", "is_trouble_back_sleep")
    insoms << data.dig("data", "baseline", "is_overall_sleep_quality")
    return if insoms.count(&:blank?).positive?
    insoms.sum(&:to_i)
  end

  def report_fosq(data)
    return if data.nil?
    fosqs = []
    fosqs << data.dig("data", "baseline", "fosq_concentrating")
    fosqs << data.dig("data", "baseline", "fosq_remembering")
    fosqs << data.dig("data", "baseline", "fosq_relationships")
    fosqs << data.dig("data", "baseline", "fosq_active_evening")
    fosqs << data.dig("data", "baseline", "fosq_active_morning")
    fosqs << data.dig("data", "baseline", "fosq_operating_motor_less100")
    fosqs << data.dig("data", "baseline", "fosq_operating_motor_greater100")
    fosqs << data.dig("data", "baseline", "fosq_watching_movie")
    fosqs << data.dig("data", "baseline", "fosq_visiting")
    fosqs << data.dig("data", "baseline", "fosq_desire")
    return if fosqs.count(&:blank?).positive?
    subscales = []
    subscales << mean_weighted(fosqs[0..1].collect(&:to_i))
    subscales << mean_weighted(fosqs[2..4].collect(&:to_i))
    subscales << mean_weighted(fosqs[5..7].collect(&:to_i))
    subscales << mean_weighted(fosqs[8..8].collect(&:to_i))
    subscales << mean_weighted(fosqs[9..9].collect(&:to_i))
    scale = mean_weighted(subscales)
    (scale * 5).to_i
  end

  def mean_weighted(array)
    array.reject!(&:zero?)
    return 0 if array.blank?
    array.sum.to_f / array.count
  end

  def report_ess(data)
    return if data.nil?
    e1 = data.dig("data", "baseline", "ess_sitting_reading")
    e2 = data.dig("data", "baseline", "ess_sitting_reading")
    e3 = data.dig("data", "baseline", "ess_watching_tv")
    e4 = data.dig("data", "baseline", "ess_public_place")
    e5 = data.dig("data", "baseline", "ess_car_passenger")
    e6 = data.dig("data", "baseline", "ess_lying_down_rest")
    e7 = data.dig("data", "baseline", "ess_sitting_talking")
    e8 = data.dig("data", "baseline", "ess_after_lunch")
    e9 = data.dig("data", "baseline", "ess_traffic")
    return if e1.blank? || e2.blank? || e3.blank? || e4.blank? || e5.blank? || e6.blank? || e7.blank? || e8.blank? || e9.blank?
    e1.to_i + e2.to_i + e3.to_i + e4.to_i + e5.to_i + e6.to_i + e7.to_i + e8.to_i + e9.to_i
  end

  def report_well_being(data)
    return if data.nil?
    whos = []
    whos << data.dig("data", "baseline", "who_cheerful")
    whos << data.dig("data", "baseline", "who_calm")
    whos << data.dig("data", "baseline", "who_active")
    whos << data.dig("data", "baseline", "who_fresh")
    whos << data.dig("data", "baseline", "who_things_interest_me")
    return if whos.count(&:blank?).positive?
    whos.sum(&:to_i) * 4
  end

  def report_bmi(data)
    return if data.nil?
    height = data.dig("data", "baseline", "dem_height")
    weight = data.dig("data", "baseline", "dem_weight")
    return unless weight.is_a?(Numeric) && height.is_a?(Numeric) && height.positive?
    weight * 703.0 / (height * height)
  end
end
