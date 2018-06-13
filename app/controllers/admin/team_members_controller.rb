# frozen_string_literal: true

# Allows admins to modify team members page.
class Admin::TeamMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_admin_team_member_or_redirect, only: [
    :show, :edit, :update, :destroy
  ]

  layout "layouts/full_page_sidebar"

  # GET /admin/team-members/order
  def order
    @admin_team_members = Admin::TeamMember.current.order("position nulls last")
  end

  # POST /admin/team-members/order.js
  def update_order
    params[:team_member_ids].each_with_index do |team_member_id, index|
      team_member = Admin::TeamMember.find_by(id: team_member_id)
      team_member&.update(position: index)
    end
    head :ok
  end

  # GET /admin/team-members
  def index
    @admin_team_members = Admin::TeamMember.current.order("position nulls last").page(params[:page]).per(40)
  end

  # GET /admin/team-members/1
  def show
    redirect_to admin_team_members_path
  end

  # GET /admin/team-members/new
  def new
    @admin_team_member = Admin::TeamMember.new
  end

  # # GET /admin/team-members/1/edit
  # def edit
  # end

  # POST /admin/team-members
  def create
    @admin_team_member = Admin::TeamMember.new(admin_team_member_params)
    if @admin_team_member.save
      redirect_to @admin_team_member, notice: "Team member was successfully created."
    else
      render :new
    end
  end

  # PATCH /admin/team-members/1
  def update
    if @admin_team_member.update(admin_team_member_params)
      redirect_to @admin_team_member, notice: "Team member was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /admin/team-members/1
  # DELETE /admin/team-members/1.json
  def destroy
    @admin_team_member.destroy
    redirect_to admin_team_members_path, notice: "Team member was successfully deleted."
  end

  private

  def find_admin_team_member_or_redirect
    @admin_team_member = Admin::TeamMember.find_by(id: params[:id])
    empty_response_or_root_path(admin_team_members_path) unless @admin_team_member
  end

  def admin_team_member_params
    params.require(:admin_team_member).permit(
      :name, :designations, :role, :bio, :photo
    )
  end
end
