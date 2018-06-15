# frozen_string_literal: true

require "test_helper"

# Tests to assure that admins can create and update broadcast categories.
class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_category = admin_categories(:announcements)
    @admin = users(:admin)
  end

  def category_params
    {
      name: "New Category",
      slug: "new-slug",
      show_on_blog_roll: "1"
    }
  end

  test "should get index" do
    login(@admin)
    get admin_categories_url
    assert_response :success
  end

  test "should get new" do
    login(@admin)
    get new_admin_category_url
    assert_response :success
  end

  test "should create category" do
    login(@admin)
    assert_difference("Admin::Category.count") do
      post admin_categories_url, params: { admin_category: category_params }
    end
    assert_redirected_to admin_category_url(Admin::Category.last)
  end

  test "should not create category with blank name" do
    login(@admin)
    assert_difference("Admin::Category.count", 0) do
      post admin_categories_url, params: {
        admin_category: category_params.merge(name: "")
      }
    end
    assert_response :success
  end

  test "should show category" do
    login(@admin)
    get admin_category_url(@admin_category)
    assert_response :success
  end

  test "should get edit" do
    login(@admin)
    get edit_admin_category_url(@admin_category)
    assert_response :success
  end

  test "should update category" do
    login(@admin)
    patch admin_category_url(@admin_category), params: {
      admin_category: category_params
    }
    @admin_category.reload
    assert_redirected_to admin_category_url(@admin_category)
  end

  test "should not update category with blank name" do
    login(@admin)
    patch admin_category_url(@admin_category), params: {
      admin_category: category_params.merge(name: "")
    }
    assert_response :success
  end

  test "should destroy category" do
    login(@admin)
    assert_difference("Admin::Category.current.count", -1) do
      delete admin_category_url(@admin_category)
    end
    assert_redirected_to admin_categories_url
  end
end
