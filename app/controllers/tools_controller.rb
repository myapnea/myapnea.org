class ToolsController < ApplicationController
  def risk_assessment
  end

  def risk_assessment_results
    @bp = [params[:systolic].to_i,params[:diastolic].to_i]
    @stop_score = (params[:snoring] ? 1 : 0) + (params[:tiredness] ? 1 : 0) + (params[:observation] ? 1 : 0) + ((params[:systolic].to_i > 140 and params[:diastolic].to_i > 90) ? 1 : 0)
    @bmi = calculateBMI
    @has_large_neck = params[:neck]
    @is_male = params[:gender] == 'male'
    @bang_score = (@bmi > 35 ? 1 : 0) + (params[:age].to_i > 50 ? 1 : 0) + (@has_large_neck ? 1 : 0) + (@is_male ? 1 : 0)
    @risk_category = riskCategory(@stop_score, @stop_score + @bang_score, @has_large_neck, @is_male, @bmi > 35)
  end

  def calculateBMI
    height = params[:feet].to_f * 12 + params[:inches].to_f
    weight = params[:weight].to_f
    bmi = (weight / (height ** 2)) * 703
    return bmi
  end

  def riskCategory(stop, stopbang, neck, male, bmi)
    if stopbang <= 2
      risk_category = 1
    elsif stopbang <= 4
      risk_category = 2
    else
      risk_category = 3
    end
    if stop >= 2 and (male or bmi or neck)
      risk_category = 3
    end
    return risk_category
  end
end
