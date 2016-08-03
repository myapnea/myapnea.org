# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!,    except: [:photo]
  before_action :check_owner,           except: [:photo]
  before_action :set_user,              only: [:show, :photo, :edit, :update, :destroy]
  before_action :redirect_without_user, only: [:show, :photo, :edit, :update, :destroy]

  def photo
    if @user.photo.size > 0
      send_file File.join(CarrierWave::Uploader::Base.root, @user.photo.url)
    else
      head :ok
    end
  end

  def index
    @all_users = User.current.search(params[:search]).order(current_sign_in_at: :desc)
    @order = scrub_order(User, params[:order], 'current_sign_in_at desc')
    @users = @all_users.reorder(@order).page(params[:page]).per(40)
  end

  def export
    @csv_string = CSV.generate do |csv|
      csv << ['Email', 'First Name', 'Last Name', 'Number of Surveys Completed']

      User.current.each do |user|
        row = [
          user.email,
          user.first_name,
          user.last_name,
          user.completed_answer_sessions.count
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"#{ENV['website_name'].gsub(/[^\w\.]/, '_')} Users List - #{Time.zone.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def set_user
    @user = User.current.find_by_id(params[:id])
  end

  def redirect_without_user
    empty_response_or_root_path(users_path) unless @user
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :forum_name, :emails_enabled,
      :age, :gender, :include_in_exports,
      :owner, :moderator, :community_contributor, :can_build_surveys,
      :shadow_banned
    )
  end
end
