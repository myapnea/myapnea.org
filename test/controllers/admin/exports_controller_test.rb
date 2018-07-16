# frozen_string_literal: true

require "test_helper"

# Tests to assure data can be exported by admins.
class Admin::ExportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @regular = users(:regular)
    @admin_export = admin_exports(:started)
    @completed = admin_exports(:completed)
  end

  def admin_export_params
    {
      completed_steps: @admin_export.completed_steps,
      zipped_file: @admin_export.zipped_file,
      total_steps: @admin_export.total_steps,
      user_id: @admin_export.user_id
    }
  end

  test "should get index as admin" do
    login(@admin)
    get admin_exports_url
    assert_response :success
  end

  test "should not get index as regular user" do
    login(@regular)
    get admin_exports_url
    assert_redirected_to root_url
  end

  test "should create admin export as admin" do
    login(@admin)
    assert_difference("Admin::Export.count") do
      post admin_exports_url, params: { admin_export: admin_export_params }
    end
    assert_redirected_to admin_export_url(Admin::Export.last)
  end

  test "should not create admin export as regular user" do
    login(@regular)
    assert_difference("Admin::Export.count", 0) do
      post admin_exports_url, params: { admin_export: admin_export_params }
    end
    assert_redirected_to root_url
  end

  test "should show admin export as admin" do
    login(@admin)
    get admin_export_url(@admin_export)
    assert_response :success
  end

  test "should not show admin export as regular user" do
    login(@regular)
    get admin_export_url(@admin_export)
    assert_redirected_to root_url
  end

  test "should get progress as admin" do
    login(@admin)
    post progress_admin_export_url(@admin_export, format: "js")
    assert_response :success
  end

  test "should not get progress as regular user" do
    login(@regular)
    post progress_admin_export_url(@admin_export, format: "js")
    assert_redirected_to root_url
  end

  test "should download export file as admin" do
    login(@admin)
    assert_not_equal 0, @completed.zipped_file.size
    get download_admin_export_url(@completed)
    assert_equal File.binread(@completed.zipped_file.path), response.body
  end

  test "should not download export file as regular user" do
    login(@regular)
    get download_admin_export_url(@completed)
    assert_redirected_to root_url
  end

  test "should destroy admin export as admin" do
    login(@admin)
    assert_difference("Admin::Export.count", -1) do
      delete admin_export_url(@admin_export)
    end
    assert_redirected_to admin_exports_url
  end

  test "should destroy admin export using ajax" do
    login(@admin)
    assert_difference("Admin::Export.count", -1) do
      delete admin_export_url(@admin_export, format: "js")
    end
    assert_response :success
  end

  test "should not destroy admin export as regular user" do
    login(@regular)
    assert_difference("Admin::Export.count", 0) do
      delete admin_export_url(@admin_export)
    end
    assert_redirected_to root_url
  end
end
