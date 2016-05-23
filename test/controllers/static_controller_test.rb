# frozen_string_literal: true

require 'test_helper.rb'

class StaticControllerTest < ActionController::TestCase
  # TODO: Non static pages should be moved
  test 'should redirect to a provider show page' do
    get :provider_page, slug: 'health-hospital'

    assert_redirected_to provider_path(users(:provider).slug)
  end

  test 'should redirect to a providers index with invalid slug' do
    get :provider_page, slug: nil

    assert_redirected_to providers_path
  end

  # STATIC
  test 'should get about' do
    get :about
    assert_response :success
  end

  test 'should get team' do
    get :team
    assert_response :success
  end

  test 'should get PEP corner' do
    get :pep_corner
    assert_response :success
  end

  test 'should get PEP corner show' do
    get :pep_corner_show, pep_id: admin_team_members(:one)
    assert_response :success
  end

  test 'should get governance charter' do
    get :governance_policy
    assert_response :success
  end

  test 'should get PEP charter' do
    get :PEP_charter
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

  test 'should get faqs' do
    get :faqs
    assert_response :success
  end

  test 'should get clinical trials' do
    get :clinical_trials
    assert_response :success
  end

  test 'should get version' do
    get :version
    assert_response :success
  end

  test 'should get version as json' do
    get :version, format: 'json'
    version = JSON.parse(response.body)
    assert_equal WwwMyapneaOrg::VERSION::STRING, version['version']['string']
    assert_equal WwwMyapneaOrg::VERSION::MAJOR, version['version']['major']
    assert_equal WwwMyapneaOrg::VERSION::MINOR, version['version']['minor']
    assert_equal WwwMyapneaOrg::VERSION::TINY, version['version']['tiny']
    assert_equal WwwMyapneaOrg::VERSION::BUILD, version['version']['build']
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
