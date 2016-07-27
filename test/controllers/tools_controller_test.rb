# frozen_string_literal: true

require 'test_helper'

class ToolsControllerTest < ActionController::TestCase
  test 'should get sleep apnea and bmi' do
    get :bmi_ahi
    assert_response :success
  end

  test 'should get risk assessment' do
    get :risk_assessment
    assert_response :success
  end

  test 'should calculate risk assessment results for stop bang parameters' do
    post :risk_assessment_results, params: {
      snoring: 'yes', tiredness: 'yes', observation: 'yes', hbp: 'yes'
    }
    assert_equal 4, assigns(:stop_score)
    assert_redirected_to sleep_apnea_risk_assessment_results_path(category: 2, score: 4)
  end

  test 'should calculate risk assessment results for bmi parameters' do
    post :risk_assessment_results, params: {
      feet: '6', inches: '5', weight: '300'
    }
    assert_equal 36, assigns(:bmi).ceil
    assert_redirected_to sleep_apnea_risk_assessment_results_path(category: 1, score: 1)
  end

  test 'should calculate risk assessment results for risk factor parameters' do
    post :risk_assessment_results, params: {
      neck: 'yes', gender: 'male', age: '51'
    }
    assert_equal true, assigns(:has_large_neck)
    assert_equal true, assigns(:is_male)
    assert_redirected_to sleep_apnea_risk_assessment_results_path(category: 2, score: 3)
  end

  test 'should calculate risk assessment for multiple parameters' do
    post :risk_assessment_results, params: {
      snoring: 'yes', tiredness: 'yes', observation: 'yes', hbp: 'yes',
      feet: '6', inches: '5', weight: '300', neck: 'yes', gender: 'male',
      age: '51'
    }
    assert_equal 4, assigns(:stop_score)
    assert_equal 4, assigns(:bang_score)
    assert_redirected_to sleep_apnea_risk_assessment_results_path(category: 3, score: 8)
  end

  test 'should get risk assessment results' do
    get :risk_assessment_results
    assert_redirected_to sleep_apnea_risk_assessment_results_path(category: 1, score: 0)
  end

  test 'should get risk assessment results display' do
    get :risk_assessment_results_display
    assert_response :success
  end
end
