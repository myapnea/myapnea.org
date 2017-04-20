# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure static pages are displayed to public users.
class StaticControllerTest < ActionController::TestCase
  test 'should get about' do
    get :about
    assert_response :success
  end

  test 'should get team' do
    get :team
    assert_response :success
  end

  test 'should get governance charter' do
    get :governance_policy
    assert_response :success
  end

  test 'should get PEP charter' do
    get :pep_charter
    assert_response :success
  end

  test 'should get partners' do
    get :partners
    assert_response :success
  end

  test 'should get learn' do
    get :learn
    assert_response :success
  end

  test 'should get clinical trials' do
    get :clinical_trials
    assert_response :success
  end

  test 'should get sitemap' do
    get :sitemap
    assert_response :success
  end

  # PAP devices
  test 'should get PAP' do
    get :pap
    assert_response :success
  end

  test 'should get about PAP therapy' do
    get :about_pap_therapy
    assert_response :success
  end

  test 'should get PAP setup guide' do
    get :pap_setup_guide
    assert_response :success
  end

  test 'should get PAP troubleshooting guide' do
    get :pap_troubleshooting_guide
    assert_response :success
  end

  test 'should get PAP care maintenance' do
    get :pap_care_maintenance
    assert_response :success
  end

  test 'should get PAP masks equipment' do
    get :pap_masks_equipment
    assert_response :success
  end

  test 'should get traveling with PAP' do
    get :traveling_with_pap
    assert_response :success
  end

  test 'should get side effects PAP' do
    get :side_effects_pap
    assert_response :success
  end

  test 'should get marketing' do
    get :marketing
    assert_response :success
  end
end
