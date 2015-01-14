class RegistrationsController < Devise::RegistrationsController
  layout 'layouts/cleantheme'

  def new

    @referring_provider = Provider.find_by_slug(params[:slug])
    super
  end

  private

  def sign_up_params
    if params[:type] == "provider"
      params.require(:provider).permit(:first_name, :last_name, :provider_name, :slug, :address_1, :address_2, :city, :state_code, :zip_code, :email, :password, :password_confirmation)
    else
      params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :provider_name, :provider_id)
    end

  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :current_password)
  end


end
