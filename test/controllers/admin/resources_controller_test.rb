# frozen_string_literal: true

require "test_helper"

# Test to make sure admins can manage resources.
class Admin::ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @admin_resource = admin_resources(:one)
  end

  def admin_resource_params
    {
      deleted: @admin_resource.deleted,
      description: @admin_resource.description,
      displayed: @admin_resource.displayed,
      link: @admin_resource.link,
      name: @admin_resource.name,
      photo: @admin_resource.photo,
      position: @admin_resource.position
    }
  end

  test "should get index" do
    login(@admin)
    get admin_resources_url
    assert_response :success
  end

  test "should get new" do
    login(@admin)
    get new_admin_resource_url
    assert_response :success
  end

  test "should create resource" do
    login(@admin)
    assert_difference("Admin::Resource.count") do
      post admin_resources_url, params: { admin_resource: admin_resource_params }
    end
    assert_redirected_to admin_resource_url(Admin::Resource.last)
  end

  test "should show resource" do
    login(@admin)
    get admin_resource_url(@admin_resource)
    assert_response :success
  end

  test "should get edit" do
    login(@admin)
    get edit_admin_resource_url(@admin_resource)
    assert_response :success
  end

  test "should update resource" do
    login(@admin)
    patch admin_resource_url(@admin_resource), params: {
      admin_resource: admin_resource_params
    }
    assert_redirected_to admin_resource_url(@admin_resource)
  end

  test "should destroy resource" do
    login(@admin)
    assert_difference("Admin::Resource.current.count", -1) do
      delete admin_resource_url(@admin_resource)
    end
    assert_redirected_to admin_resources_url
  end
end
