# frozen_string_literal: true

require 'test_helper'

class Builder::EncountersControllerTest < ActionController::TestCase
  setup do
    @owner = users(:owner)
    @regular_user = users(:user_1)
    @encounter = encounters(:baseline)
  end

  test 'should get encounters as owner' do
    login(@owner)
    get :index
    assert_not_nil assigns(:encounters)
  end

  test 'should not get encounters as regular user' do
    login(@regular_user)
    get :index
    assert_nil assigns(:encounters)
    assert_redirected_to root_path
  end

  test 'should get new encounter as owner' do
    login(@owner)
    get :new
    assert_not_nil assigns(:encounter)
    assert_response :success
  end

  test 'should not get new encounter as regular user' do
    login(@regular_user)
    get :new
    assert_nil assigns(:encounter)
    assert_redirected_to root_path
  end

  test 'should create encounter as builder' do
    login(@owner)
    assert_difference('Encounter.count') do
      post :create, params: { encounter: { name: 'My New Encounter', slug: 'my-new-encounter', launch_days_after_sign_up: 10 } }
    end
    assert_not_nil assigns(:encounter)
    assert_equal 'My New Encounter', assigns(:encounter).name
    assert_equal 'my-new-encounter', assigns(:encounter).slug
    assert_equal 10, assigns(:encounter).launch_days_after_sign_up
    assert_redirected_to builder_encounter_path(assigns(:encounter))
  end

  test 'should not create encounter without text' do
    login(@owner)
    assert_difference('Encounter.count', 0) do
      post :create, params: { encounter: { name: '', slug: 'my-new-encounter', launch_days_after_sign_up: 10 } }
    end
    assert_not_nil assigns(:encounter)
    assert assigns(:encounter).errors.size > 0
    assert_equal ["can't be blank"], assigns(:encounter).errors[:name]
    assert_template 'encounters/new'
    assert_response :success
  end

  test 'should not create encounter as regular user' do
    login(@regular_user)
    assert_difference('Encounter.count', 0) do
      post :create, params: { encounter: { name: 'My New Encounter', slug: 'my-new-encounter', launch_days_after_sign_up: 10 } }
    end
    assert_nil assigns(:encounter)
    assert_redirected_to root_path
  end

  test 'should show encounter as owner' do
    login(@owner)
    get :show, params: { id: @encounter }
    assert_not_nil assigns(:encounter)
    assert_response :success
  end

  test 'should not show encounter as regular user' do
    login(@regular_user)
    get :show, params: { id: @encounter }
    assert_nil assigns(:encounter)
    assert_redirected_to root_path
  end

  test 'should get edit encounter as owner' do
    login(@owner)
    get :edit, params: { id: @encounter }
    assert_not_nil assigns(:encounter)
    assert_response :success
  end

  test 'should not get edit encounter as regular user' do
    login(@regular_user)
    get :edit, params: { id: @encounter }
    assert_nil assigns(:encounter)
    assert_redirected_to root_path
  end

  test 'should update encounter as owner' do
    login(@owner)
    patch :update, params: { id: @encounter, encounter: { name: 'Updated Encounter', slug: 'updated-encounter', launch_days_after_sign_up: 90 } }
    assert_not_nil assigns(:encounter)
    assert_equal 'Updated Encounter', assigns(:encounter).name
    assert_equal 'updated-encounter', assigns(:encounter).slug
    assert_equal 90, assigns(:encounter).launch_days_after_sign_up
    assert_redirected_to builder_encounter_path(assigns(:encounter))
  end

  test 'should not update encounter without name' do
    login(@owner)
    patch :update, params: { id: @encounter, encounter: { name: '', slug: 'updated-encounter', launch_days_after_sign_up: 90 } }
    assert_not_nil assigns(:encounter)
    assert assigns(:encounter).errors.size > 0
    assert_equal ["can't be blank"], assigns(:encounter).errors[:name]
    assert_template 'encounters/edit'
    assert_response :success
  end

  test 'should not update encounter as regular user' do
    login(@regular_user)
    patch :update, params: { id: @encounter, encounter: { name: 'Updated Encounter', slug: 'updated-encounter', launch_days_after_sign_up: 90 } }
    assert_nil assigns(:encounter)
    assert_redirected_to root_path
  end

  test 'should destroy encounter as owner' do
    login(@owner)
    assert_difference('Encounter.current.count', -1) do
      delete :destroy, params: { id: @encounter }
    end
    assert_not_nil assigns(:encounter)
    assert_redirected_to builder_encounters_path
  end

  test 'should not destroy encounter as regular user' do
    login(@regular_user)
    assert_difference('Encounter.current.count', 0) do
      delete :destroy, params: { id: @encounter }
    end
    assert_nil assigns(:encounter)
    assert_redirected_to root_path
  end
end
