require 'test_helper'

class EngagementsControllerTest < ActionController::TestCase
  setup do
    @engagement = engagements(:one)
    @owner = users(:owner)
  end

  test "should get index for owner" do
    get :index
    assert_response :redirect
    login(@owner)
    get :index
    assert_response :success
    assert_not_nil assigns(:engagements)
  end

  test "should get new for owner" do
    get :new
    assert_response :redirect
    login(@owner)
    get :new
    assert_response :success
  end

  test "should create engagement as owner" do
    assert_no_difference('Engagement.current.count') do
      post :create, engagement: { adult_at_risk: true, text: 'New engagement text', user_id: @owner }
    end

    login(@owner)
    assert_difference('Engagement.current.count') do
      post :create, engagement: { adult_at_risk: true, text: 'New engagement text', user_id: @owner }
    end
    assert_redirected_to engagement_path(assigns(:engagement))
  end

  test "should show engagement" do
    get :show, id: @engagement
    assert_response :redirect
    login(@owner)
    get :show, id: @engagement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @engagement
    assert_response :redirect
    login(@owner)
    get :edit, id: @engagement
    assert_response :success
  end

  test "should update engagement" do
    patch :update, id: @engagement, engagement: { researcher: true }
    assert_response :redirect
    login(@owner)
    patch :update, id: @engagement, engagement: { researcher: true }
    assert_redirected_to engagement_path(assigns(:engagement))
  end

  test "should destroy engagement" do
    assert_no_difference('Engagement.current.count') do
      delete :destroy, id: @engagement
    end

    login(@owner)
    assert_difference('Engagement.current.count', -1) do
      delete :destroy, id: @engagement
    end
    assert_redirected_to engagements_path
  end
end
