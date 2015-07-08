class RegistrationsController < Devise::RegistrationsController

  layout 'layouts/application-no-sidebar'

  def new
    @user = User.new(first_name: params["first_name"], last_name: params["last_name"], over_eighteen: params["over_eighteen"], email: params["email"], password: params["password"], invite_token: params["invite_token"], provider_id: params["provider_id"])
    respond_to do |format|
      if @user.save
        format.html
        format.json { render json: @user }
      else
        format.html
        format.json { render json: "Please provide all appropriate parameters (first name, last name, age confirmation, email, and valid password)" }
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    get_started_path
  end

  private

  def sign_up_params
    if params[:user][:provider]
      params.require(:user).permit(:first_name, :last_name,                 :email, :password, :beta_opt_in, :invite_token, :provider, :welcome_message)
    else
      params.require(:user).permit(:first_name, :last_name, :over_eighteen, :email, :password, :beta_opt_in, :invite_token, :provider_id)
    end

  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :current_password)
  end

end
