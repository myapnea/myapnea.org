require 'test_helper'

class Admin::ExportsControllerTest < ActionController::TestCase
  setup do
    @owner = users(:owner)
    @regular_user = users(:user_1)
    @admin_export = admin_exports(:started)
    @completed = admin_exports(:completed)
  end

  test 'should get index as owner' do
    login(@owner)
    get :index
    assert_not_nil assigns(:admin_exports)
    assert_response :success
  end

  test 'should not get index as regular user' do
    login(@regular_user)
    get :index
    assert_redirected_to root_path
  end

  test 'should create admin export as owner' do
    login(@owner)
    assert_difference('Admin::Export.count') do
      post :create, admin_export: { current_step: @admin_export.current_step, file: @admin_export.file, total_steps: @admin_export.total_steps, user_id: @admin_export.user_id }
    end

    assert_redirected_to admin_export_path(assigns(:admin_export))
  end

  test 'should not create admin export as regular user' do
    login(@regular_user)
    assert_difference('Admin::Export.count', 0) do
      post :create, admin_export: { current_step: @admin_export.current_step, file: @admin_export.file, total_steps: @admin_export.total_steps, user_id: @admin_export.user_id }
    end

    assert_redirected_to root_path
  end

  test 'should show admin export as owner' do
    login(@owner)
    get :show, id: @admin_export
    assert_response :success
  end

  test 'should not show admin export as regular user' do
    login(@regular_user)
    get :show, id: @admin_export
    assert_redirected_to root_path
  end

  test 'should get progress as owner' do
    login(@owner)
    post :progress, id: @admin_export, format: 'js'
    assert_template 'progress'
    assert_response :success
  end

  test 'should not get progress as regular user' do
    login(@regular_user)
    post :progress, id: @admin_export, format: 'js'
    assert_redirected_to root_path
  end

  test 'should download export file as owner' do
    login(@owner)
    assert_not_equal 0, @completed.file.size
    get :file, id: @completed
    assert_not_nil assigns(:admin_export)
    assert_not_nil response
    assert_kind_of String, response.body
    assert_equal File.binread(File.join(CarrierWave::Uploader::Base.root, assigns(:admin_export).file.url)), response.body
  end

  test 'should not download export file as regular user' do
    login(@regular_user)
    get :file, id: @completed
    assert_nil assigns(:admin_export)
    assert_redirected_to root_path
  end

  test 'should destroy admin_export as owner' do
    login(@owner)
    assert_difference('Admin::Export.count', -1) do
      delete :destroy, id: @admin_export
    end

    assert_redirected_to admin_exports_path
  end

  test 'should not destroy admin export as regular user' do
    login(@regular_user)
    assert_difference('Admin::Export.count', 0) do
      delete :destroy, id: @admin_export
    end

    assert_redirected_to root_path
  end
end
