# frozen_string_literal: true

require 'test_helper'

class Admin::ClinicalTrialsControllerTest < ActionController::TestCase
  setup do
    @admin = users(:owner)
    @admin_clinical_trial = admin_clinical_trials(:one)
  end

  def admin_clinical_trial_params
    {
      deleted: @admin_clinical_trial.deleted,
      description: @admin_clinical_trial.description,
      displayed: @admin_clinical_trial.displayed,
      eligibility: @admin_clinical_trial.eligibility,
      email: @admin_clinical_trial.email,
      overview: @admin_clinical_trial.overview,
      phone: @admin_clinical_trial.phone,
      title: @admin_clinical_trial.title
    }
  end

  test 'should get index' do
    login(@admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_clinical_trials)
  end

  test 'should get new' do
    login(@admin)
    get :new
    assert_response :success
  end

  test 'should create admin_clinical_trial' do
    login(@admin)
    assert_difference('Admin::ClinicalTrial.count') do
      post :create, params: { admin_clinical_trial: admin_clinical_trial_params }
    end

    assert_redirected_to admin_clinical_trial_path(assigns(:admin_clinical_trial))
  end

  test 'should show admin_clinical_trial' do
    login(@admin)
    get :show, params: { id: @admin_clinical_trial }
    assert_response :success
  end

  test 'should get edit' do
    login(@admin)
    get :edit, params: { id: @admin_clinical_trial }
    assert_response :success
  end

  test 'should update admin_clinical_trial' do
    login(@admin)
    patch :update, params: { id: @admin_clinical_trial, admin_clinical_trial: admin_clinical_trial_params }
    assert_redirected_to admin_clinical_trial_path(assigns(:admin_clinical_trial))
  end

  test 'should destroy admin_clinical_trial' do
    login(@admin)
    assert_difference('Admin::ClinicalTrial.current.count', -1) do
      delete :destroy, params: { id: @admin_clinical_trial }
    end

    assert_redirected_to admin_clinical_trials_path
  end
end
