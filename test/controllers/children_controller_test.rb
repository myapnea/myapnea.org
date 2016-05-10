# frozen_string_literal: true

require 'test_helper'

class ChildrenControllerTest < ActionController::TestCase
  setup do
    login(users(:user_1))
    @child = children(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:children)
  end

  test "should get index as js" do
    xhr :get, :index, format: 'js'
    assert_response :success
    assert_not_nil assigns(:children)
    assert_template 'index'
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new as js" do
    xhr :get, :new, format: 'js'
    assert_template 'new'
    assert_response :success
  end

  test "should create child" do
    assert_difference('Child.count') do
      post :create, child: { first_name: @child.first_name, age: @child.age }
    end

    assert_redirected_to child_path(assigns(:child))
  end

  test "should not create child with blank first name" do
    assert_difference('Child.count', 0) do
      post :create, child: { first_name: '', age: @child.age }
    end
    assert_not_nil assigns(:child)
    assert assigns(:child).errors.size > 0
    assert_equal ["can't be blank"], assigns(:child).errors[:first_name]
    assert_template 'new'
    assert_response :success
  end

  test "should create child as js" do
    assert_difference('Child.count') do
      xhr :post, :create, child: { first_name: @child.first_name, age: @child.age }, format: 'js'
    end

    assert_template 'show'
    assert_response :success
  end

  test "should show child" do
    get :show, id: @child
    assert_response :success
  end

  test "should show child as js" do
    xhr :get, :show, id: @child, format: 'js'
    assert_response :success
    assert_template 'show'
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @child
    assert_response :success
  end

  test "should get edit as js" do
    xhr :get, :edit, id: @child, format: 'js'
    assert_template 'edit'
    assert_response :success
  end

  test "should update child" do
    patch :update, id: @child, child: { first_name: @child.first_name, age: @child.age }
    assert_redirected_to child_path(assigns(:child))
  end

  test "should not update child with blank first name" do
    patch :update, id: @child, child: { first_name: '', age: @child.age }

    assert_not_nil assigns(:child)
    assert assigns(:child).errors.size > 0
    assert_equal ["can't be blank"], assigns(:child).errors[:first_name]
    assert_template 'edit'
    assert_response :success
  end

  test "should update child as js" do
    xhr :patch, :update, id: @child, child: { first_name: @child.first_name, age: @child.age }, format: 'js'
    assert_template 'show'
    assert_response :success
  end

  test "should accept consent child as js" do
    xhr :patch, :accept_consent, id: @child, child: { first_name: @child.first_name, age: @child.age }, format: 'js'
    assert_not_nil assigns(:child)
    assert_not_nil assigns(:child).accepted_consent_at
    assert_template 'show'
    assert_response :success
  end

  test "should destroy child" do
    assert_difference('Child.current.count', -1) do
      delete :destroy, id: @child
    end

    assert_redirected_to children_path
  end

  test "should destroy child as js" do
    assert_difference('Child.current.count', -1) do
      xhr :delete, :destroy, id: @child, format: 'js'
    end

    assert_template 'index'
    assert_response :success
  end
end
