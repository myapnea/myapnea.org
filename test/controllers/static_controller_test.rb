require 'test_helper.rb'

class StaticControllerTest < ActionController::TestCase

  test "should get landing for logged out user" do
    get :home
    assert_template 'landing'
    assert_response :success
  end

  test "should get home for regular user" do
    login(users(:user_1))
    get :home
    assert_template 'home'
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get share" do
    get :share
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

  test "should redirect to a provider show page" do
    get :provider_page, slug: 'health-hospital'

    assert_redirected_to provider_path(users(:provider_1).slug)
  end

  test "should redirect to a providers index with invalid slug" do
    get :provider_page, slug: nil

    assert_redirected_to providers_path
  end

end
