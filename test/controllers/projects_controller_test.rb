# frozen_string_literal: true

require "test_helper"

# Tests to assure admins can manage projects.
class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
    @admin = users(:admin)
  end

  def project_params
    {
      name: @project.name,
      slug: @project.slug,
      short_description: @project.short_description,
      consent: @project.consent,
      launch_date: @project.launch_date,
      theme: @project.theme,
      access_token: "access-66d74521",
      published: "1",
      slice_site_id: "12345",
      code_prefix: "TEST"
    }
  end

  test "should get index" do
    login(@admin)
    get projects_path
    assert_response :success
  end

  test "should get new" do
    login(@admin)
    get new_project_path
    assert_response :success
  end

  test "should create project" do
    login(@admin)
    assert_difference("Project.count") do
      post projects_path, params: {
        project: project_params.merge(slug: "new-project")
      }
    end
    assert_redirected_to project_path(Project.last)
  end

  test "should show project" do
    login(@admin)
    get project_path(@project)
    assert_response :success
  end

  test "should get edit" do
    login(@admin)
    get edit_project_path(@project)
    assert_response :success
  end

  test "should update project" do
    login(@admin)
    patch project_path(@project), params: { project: project_params }
    assert_redirected_to project_path(@project)
  end

  test "should destroy project" do
    login(@admin)
    assert_difference("Project.current.count", -1) do
      delete project_path(@project)
    end
    @project.reload
    assert_nil @project.slug
    assert_redirected_to projects_path
  end
end
