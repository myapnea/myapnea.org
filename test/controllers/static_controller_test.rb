require 'test_helper.rb'

class StaticControllerTest < ActionController::TestCase

  ## NON-STATIC


  test "should redirect to a provider show page" do
    get :provider_page, slug: 'health-hospital'

    assert_redirected_to provider_path(users(:provider).slug)
  end

  test "should redirect to a providers index with invalid slug" do
    get :provider_page, slug: nil

    assert_redirected_to providers_path
  end

  ## STATIC

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get team" do
    get :team
    assert_response :success
  end

  test "should get advisory" do
    get :advisory
    # assert_response :success
    assert_redirected_to team_path
  end

  test "should get governance charter" do
    get :governance_policy
    assert_response :success
  end

  test "should get PEP charter" do
    get :PEP_charter
    assert_response :success
  end

  test "should get advisory charter" do
    get :AC_charter
    # assert_response :success
    assert_redirected_to team_path
  end

  test "should get partners" do
    get :partners
    assert_response :success
  end

  test "should get learn" do
    get :learn
    assert_response :success
  end

  test "should get faqs" do
    get :faqs
    assert_response :success
  end

  test "should get clinical trials" do
    get :clinical_trials
    assert_response :success
  end

  test "should get version" do
    get :version
    assert_response :success
  end

  test "should get version as json" do
    get :version, format: 'json'
    version = JSON.parse(response.body)
    assert_equal WwwMyapneaOrg::VERSION::STRING, version['version']['string']
    assert_equal WwwMyapneaOrg::VERSION::MAJOR, version['version']['major']
    assert_equal WwwMyapneaOrg::VERSION::MINOR, version['version']['minor']
    assert_equal WwwMyapneaOrg::VERSION::TINY, version['version']['tiny']
    assert_equal WwwMyapneaOrg::VERSION::BUILD, version['version']['build']
    assert_response :success
  end

  test "should get sitemap" do
    get :sitemap
    assert_response :success
  end

  ## Educational content

  test "should get what is sleep apnea" do
    get :what_is_sleep_apnea
    assert_response :success
  end

  test "should get obstructive sleep apnea" do
    get :obstructive_sleep_apnea
    assert_response :success
  end

  test "should get central sleep apnea" do
    get :central_sleep_apnea
    assert_response :success
  end

  test "should get causes of sleep apnea" do
    get :causes
    assert_response :success
  end

  test "should get symptoms of sleep apnea" do
    get :symptoms
    assert_response :success
  end

  test "should get risk factors for sleep apnea" do
    get :risk_factors
    assert_response :success
  end

  test "should get diagnosis of sleep apnea" do
    get :diagnostic_process
    assert_response :success
  end

  test "should get treatment options for sleep apnea" do
    get :treatment_options
    assert_response :success
  end

  # PAP devices

  test "should get PAP" do
    get :pap
    assert_response :success
  end

  test "should get about PAP therapy" do
    get :about_PAP_therapy
    assert_response :success
  end

  test "should get PAP setup guide" do
    get :PAP_setup_guide
    assert_response :success
  end

  test "should get PAP troubleshooting guide" do
    get :PAP_troubleshooting_guide
    assert_response :success
  end

  test "should get PAP care maintenance" do
    get :PAP_care_maintenance
    assert_response :success
  end

  test "should get PAP masks equipment" do
    get :PAP_masks_equipment
    assert_response :success
  end

  test "should get traveling with PAP" do
    get :traveling_with_PAP
    assert_response :success
  end

  test "should get side effects PAP" do
    get :side_effects_PAP
    assert_response :success
  end

  test "should only get sleep tips for admin" do
    get :sleep_tips
    assert_response :redirect

    login(users(:moderator_1))
    get :sleep_tips
    assert_response :success
  end

  test "should get sizes" do
    get :sizes
    assert_response :success
  end

end
