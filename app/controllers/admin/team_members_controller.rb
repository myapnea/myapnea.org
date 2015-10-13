class Admin::TeamMembersController < ApplicationController
  before_action :authenticate_user!,    except: [:photo]
  before_action :check_owner,           except: [:photo]
  before_action :set_admin_team_member, only: [:show, :edit, :update, :destroy, :photo]

  def photo
    if @admin_team_member.photo.size > 0
      send_file File.join(CarrierWave::Uploader::Base.root, @admin_team_member.photo.url)
    else
      head :ok
    end
  end

  # GET /admin/team_members
  # GET /admin/team_members.json
  def index
    @admin_team_members = Admin::TeamMember.current.order('position')
  end

  # GET /admin/team_members/1
  # GET /admin/team_members/1.json
  def show
    redirect_to admin_team_members_path
  end

  # GET /admin/team_members/new
  def new
    @admin_team_member = Admin::TeamMember.new
  end

  # GET /admin/team_members/1/edit
  def edit
  end

  # POST /admin/team_members
  # POST /admin/team_members.json
  def create
    @admin_team_member = Admin::TeamMember.new(admin_team_member_params)

    respond_to do |format|
      if @admin_team_member.save
        format.html { redirect_to @admin_team_member, notice: 'Team member was successfully created.' }
        format.json { render :show, status: :created, location: @admin_team_member }
      else
        format.html { render :new }
        format.json { render json: @admin_team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/team_members/1
  # PATCH/PUT /admin/team_members/1.json
  def update
    respond_to do |format|
      if @admin_team_member.update(admin_team_member_params)
        format.html { redirect_to @admin_team_member, notice: 'Team member was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_team_member }
      else
        format.html { render :edit }
        format.json { render json: @admin_team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/team_members/1
  # DELETE /admin/team_members/1.json
  def destroy
    @admin_team_member.destroy
    respond_to do |format|
      format.html { redirect_to admin_team_members_url, notice: 'Team member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_team_member
      @admin_team_member = Admin::TeamMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_team_member_params
      params.require(:admin_team_member).permit(:name, :designations, :role, :position, :bio, :photo, :group)
    end
end
