# frozen_string_literal: true

# Displays publicly available tools.
class ToolsController < ApplicationController
  # def risk_assessment
  # end

  def risk_assessment_results
    @stop_score = (params[:snoring] == 'yes' ? 1 : 0) + (params[:tiredness]=="yes" ? 1 : 0) + (params[:observation]=="yes" ? 1 : 0) + (params[:hbp]=="yes" ? 1 : 0)
    @bmi = calculate_bmi
    @has_large_neck = params[:neck] == 'yes'
    @is_male = params[:gender] == 'male'
    @bang_score = (@bmi > 35 ? 1 : 0) + (params[:age].to_i > 50 ? 1 : 0) + (@has_large_neck ? 1 : 0) + (@is_male ? 1 : 0)
    @risk_category = risk_category(@stop_score, @stop_score + @bang_score, @has_large_neck, @is_male, @bmi > 35)
    redirect_to sleep_apnea_risk_assessment_results_path(category: @risk_category, score: @stop_score+@bang_score)
  end

  # def risk_assessment_results_display
  # end

  # def bmi_ahi
  # end

  private

  def calculate_bmi
    height = params[:feet].to_f * 12 + params[:inches].to_f
    weight = params[:weight].to_f
    (weight / (height**2)) * 703
  end

  def risk_category(stop, stopbang, neck, male, bmi)
    risk_category = \
      if stopbang <= 2
        1
      elsif stopbang <= 4
        2
      else
        3
      end
    risk_category = 3 if stop >= 2 && (male || bmi || neck)
    risk_category
  end
end
