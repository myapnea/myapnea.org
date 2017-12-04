require "test_helper"

class UserProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_project = user_projects(:one)
    @regular = users(:valid)
  end

  def user_project_params
    {
      project_id: projects(:two).id
    }
  end

  test "should get index" do
    login(@regular)
    get user_projects_url
    assert_response :success
  end

  test "should get new" do
    login(@regular)
    get new_user_project_url
    assert_response :success
  end

  test "should create user_project" do
    login(@regular)
    assert_difference("UserProject.count") do
      post user_projects_url, params: { user_project: user_project_params }
    end
    assert_redirected_to slice_surveys_url
  end

  test "should show user_project" do
    login(@regular)
    get user_project_url(@user_project)
    assert_response :success
  end

  test "should get edit" do
    login(@regular)
    get edit_user_project_url(@user_project)
    assert_response :success
  end

  test "should update user_project" do
    login(@regular)
    patch user_project_url(@user_project), params: { user_project: user_project_params }
    assert_redirected_to slice_surveys_url
  end

  test "should destroy user_project" do
    login(@regular)
    assert_difference("UserProject.count", -1) do
      delete user_project_url(@user_project)
    end
    assert_redirected_to slice_surveys_url
  end
end
