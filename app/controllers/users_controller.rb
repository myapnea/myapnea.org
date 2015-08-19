class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  before_action :redirect_without_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @all_users = User.current.search(params[:search]).order(current_sign_in_at: :desc)
    @users = @all_users.page(params[:page]).per( 40 )
    render layout: 'application-no-sidebar'
  end

  def export
    @csv_string = CSV.generate do |csv|
      csv << ['Email', 'First Name', 'Last Name', 'Number of Surveys Completed']

      User.current.each do |user|
        row = [
          user.email,
          user.first_name,
          user.last_name,
          user.completed_surveys.count
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"#{ENV['pprn_title'].gsub(/[^\w\.]/, '_')} Users List - #{Time.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
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
      params[:user] ||= {}

      if current_user.owner?
        params.require(:user).permit(
          :first_name, :last_name, :email, :forum_name, :emails_enabled,
          :age, :gender, :include_in_exports,
          :owner, :moderator, :can_build_surveys
        )
      else
        params.require(:user).permit(
          :first_name, :last_name, :email, :forum_name, :age, :gender
        )
      end
    end

end
