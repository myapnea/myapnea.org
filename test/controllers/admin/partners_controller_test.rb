# frozen_string_literal: true

require "test_helper"

# Test to make sure admins can manage partners.
class Admin::PartnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @admin_partner = admin_partners(:one)
  end

  def admin_partner_params
    {
      deleted: @admin_partner.deleted,
      description: @admin_partner.description,
      displayed: @admin_partner.displayed,
      link: @admin_partner.link,
      name: @admin_partner.name,
      photo: @admin_partner.photo,
      position: @admin_partner.position
    }
  end

  test "should get photo for logged out user" do
    get photo_admin_partner_url(@admin_partner)
    assert_response :success
  end

  test "should get index" do
    login(@admin)
    get admin_partners_url
    assert_response :success
  end

  test "should get new" do
    login(@admin)
    get new_admin_partner_url
    assert_response :success
  end

  test "should create admin_partner" do
    login(@admin)
    assert_difference("Admin::Partner.count") do
      post admin_partners_url, params: { admin_partner: admin_partner_params }
    end
    assert_redirected_to admin_partner_url(Admin::Partner.last)
  end

  test "should show admin_partner and redirect to index" do
    login(@admin)
    get admin_partner_url(@admin_partner)
    assert_redirected_to admin_partners_url
  end

  test "should get edit" do
    login(@admin)
    get edit_admin_partner_url(@admin_partner)
    assert_response :success
  end

  test "should update admin_partner" do
    login(@admin)
    patch admin_partner_url(@admin_partner), params: {
      admin_partner: admin_partner_params
    }
    assert_redirected_to admin_partner_url(@admin_partner)
  end

  test "should destroy admin_partner" do
    login(@admin)
    assert_difference("Admin::Partner.current.count", -1) do
      delete admin_partner_url(@admin_partner)
    end
    assert_redirected_to admin_partners_url
  end
end
