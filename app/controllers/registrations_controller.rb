class RegistrationsController < Devise::RegistrationsController

  def new
    @provider = Provider.find_by_slug(params[:slug])
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :provider_name, :provider_id)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :current_password)
  end

end
