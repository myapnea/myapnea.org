class RegistrationsController < Devise::RegistrationsController

  protected

  def after_sign_up_path_for(resource)
    get_started_path
  end

  private

  def sign_up_params
    if params[:user][:provider]
      params.require(:user).permit(:first_name, :last_name,                 :email, :password, :beta_opt_in, :provider, :welcome_message)
    else
      params.require(:user).permit(:first_name, :last_name, :over_eighteen, :email, :password, :beta_opt_in, :provider_id)
    end

  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :current_password)
  end

end
