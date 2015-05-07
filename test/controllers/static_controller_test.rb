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
    assert_response :success
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

  test "should get research" do
    get :research
    assert_response :success
  end

  test "should get theme" do
    get :theme
    assert_response :success
  end

  test "should get version" do
    get :version
    assert_response :success
  end

  test "should get sitemap" do
    get :sitemap
    assert_response :success
  end

  test "should get PAP" do
    get :pap
    assert_response :success
  end

  test "should get obstructive sleep apnea" do
    get :obstructive_sleep_apnea
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

  test "should get sleep tips" do
    get :sleep_tips
    assert_response :success
  end

end
