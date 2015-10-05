require 'test_helper'

class Admin::PartnersControllerTest < ActionController::TestCase
  setup do
    @admin = users(:owner)
    @admin_partner = admin_partners(:one)
  end

  test "should get index" do
    login(@admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_partners)
  end

  test "should get new" do
    login(@admin)
    get :new
    assert_response :success
  end

  test "should create admin_partner" do
    login(@admin)
    assert_difference('Admin::Partner.count') do
      post :create, admin_partner: { deleted: @admin_partner.deleted, description: @admin_partner.description, displayed: @admin_partner.displayed, link: @admin_partner.link, name: @admin_partner.name, photo: @admin_partner.photo, position: @admin_partner.position }
    end

    assert_redirected_to admin_partner_path(assigns(:admin_partner))
  end

  test "should show admin_partner and redirect to index" do
    login(@admin)
    get :show, id: @admin_partner
    assert_redirected_to admin_partners_path
  end

  test "should get edit" do
    login(@admin)
    get :edit, id: @admin_partner
    assert_response :success
  end

  test "should update admin_partner" do
    login(@admin)
    patch :update, id: @admin_partner, admin_partner: { deleted: @admin_partner.deleted, description: @admin_partner.description, displayed: @admin_partner.displayed, link: @admin_partner.link, name: @admin_partner.name, photo: @admin_partner.photo, position: @admin_partner.position }
    assert_redirected_to admin_partner_path(assigns(:admin_partner))
  end

  test "should destroy admin_partner" do
    login(@admin)
    assert_difference('Admin::Partner.current.count', -1) do
      delete :destroy, id: @admin_partner
    end

    assert_redirected_to admin_partners_path
  end
end
