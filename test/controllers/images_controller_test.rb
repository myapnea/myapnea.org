# frozen_string_literal: true

require "test_helper"

# Tests access to upload and view images in blogs and forum posts.
class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @regular = users(:regular)
    @image = images(:one)
  end

  def fixture_rails_png
    fixture_file_upload("../../test/support/images/rails.png")
  end

  def image_params
    {
      image: fixture_rails_png
    }
  end

  def multiple_images
    [fixture_rails_png, fixture_rails_png]
  end

  test "should get index as admin" do
    login(@admin)
    get images_url
    assert_response :success
  end

  test "should not get index as public user" do
    get images_url
    assert_redirected_to new_user_session_url
  end

  test "should not get index as regular user" do
    login(@regular)
    get images_url
    assert_redirected_to root_url
  end

  test "should get new as admin" do
    login(@admin)
    get new_image_url
    assert_response :success
  end

  test "should get new as regular user" do
    login(@regular)
    get new_image_url
    assert_response :success
  end

  test "should not get new as public user" do
    get new_image_url
    assert_redirected_to new_user_session_url
  end

  test "should create image as admin" do
    login(@admin)
    assert_difference("Image.count") do
      post images_url, params: { image: image_params }
    end
    assert_redirected_to image_url(assigns(:image))
  end

  test "should create image as regular user" do
    login(@regular)
    assert_difference("Image.count") do
      post images_url, params: { image: image_params }
    end
    assert_redirected_to image_url(assigns(:image))
  end

  test "should create image as public user" do
    assert_difference("Image.count", 0) do
      post images_url, params: { image: image_params }
    end
    assert_redirected_to new_user_session_url
  end

  test "should upload multiple images as admin" do
    login(@admin)
    assert_difference("Image.count", 2) do
      post upload_images_url(format: "js"), params: { images: multiple_images }
    end
    assert_template "create_multiple"
    assert_response :success
  end

  test "should upload multiple images as regular user" do
    login(@regular)
    assert_difference("Image.count", 2) do
      post upload_images_url(format: "js"), params: { images: multiple_images }
    end
    assert_template "create_multiple"
    assert_response :success
  end

  test "should not upload multiple images as public user" do
    assert_difference("Image.count", 0) do
      post upload_images_url(format: "js"), params: { images: multiple_images }
    end
    assert_response :unauthorized
  end

  test "should show image as admin" do
    login(@admin)
    get image_url(@image)
    assert_response :success
  end

  test "should show image as regular user" do
    login(@regular)
    get image_url(@image)
    assert_response :success
  end

  test "should show image as public user" do
    get image_url(@image)
    assert_response :success
  end

  test "should download image as admin" do
    login(@admin)
    get download_image_url(@image)
    assert_equal File.binread(assigns(:image).image.path), response.body
    assert_response :success
  end

  test "should download image as regular user" do
    login(@regular)
    get download_image_url(@image)
    assert_equal File.binread(assigns(:image).image.path), response.body
    assert_response :success
  end

  test "should download image as public user" do
    get download_image_url(@image)
    assert_equal File.binread(assigns(:image).image.path), response.body
    assert_response :success
  end

  test "should get edit as admin" do
    login(@admin)
    get edit_image_url(@image)
    assert_response :success
  end

  test "should not get edit as regular user" do
    login(@regular)
    get edit_image_url(@image)
    assert_redirected_to root_url
  end

  test "should not get edit as public user" do
    get edit_image_url(@image)
    assert_redirected_to new_user_session_url
  end

  test "should update image as admin" do
    login(@admin)
    patch image_url(images(:three)), params: { image: image_params }
    assert_redirected_to image_url(images(:three))
  end

  test "should not update image as regular user" do
    login(@regular)
    patch image_url(images(:three)), params: { image: image_params }
    assert_redirected_to root_url
  end

  test "should not update image as public user" do
    patch image_url(images(:three)), params: { image: image_params }
    assert_redirected_to new_user_session_url
  end

  test "should destroy image as admin" do
    login(@admin)
    assert_difference("Image.count", -1) do
      delete image_url(images(:three))
    end
    assert_redirected_to images_url
  end

  test "should not destroy image as regular user" do
    login(@regular)
    assert_difference("Image.count", 0) do
      delete image_url(images(:three))
    end
    assert_redirected_to root_url
  end

  test "should not destroy image as public user" do
    assert_difference("Image.count", 0) do
      delete image_url(images(:three))
    end
    assert_redirected_to new_user_session_url
  end
end
