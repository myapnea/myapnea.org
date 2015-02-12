class RegistrationsController < Devise::RegistrationsController
  # def new
  #   #
  #   # build_resource({})
  #   # @validatable = devise_mapping.validatable?
  #   # if @validatable
  #   #   @minimum_password_length = resource_class.password_length.min
  #   # end
  #   # respond_with self.resource
  #   #
  #   super
  # end

  # def create
  #   raise StandardError
  #   build_resource(sign_up_params)
  #
  #   resource_saved = resource.save
  #   yield resource if block_given?
  #   if resource_saved
  #     if resource.active_for_authentication?
  #       set_flash_message :notice, :signed_up if is_flashing_format?
  #       sign_up(resource_name, resource)
  #       respond_with resource, location: after_sign_up_path_for(resource)
  #     else
  #       set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
  #       expire_data_after_sign_in!
  #       respond_with resource, location: after_inactive_sign_up_path_for(resource)
  #     end
  #   else
  #     clean_up_passwords resource
  #     @validatable = devise_mapping.validatable?
  #     if @validatable
  #       @minimum_password_length = resource_class.password_length.min
  #     end
  #     respond_with resource
  #   end
  # end

  protected

  def after_sign_up_path_for(resource)
    get_started_path
  end

  private

  def sign_up_params
    if params[:user][:provider]
      params.require(:user).permit(:first_name, :last_name,                 :email, :password, :beta_opt_in, :provider, :welcome_message)
    else
      params.require(:user).permit(:first_name, :last_name, :year_of_birth, :email, :password, :beta_opt_in, :provider_id)
    end

  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :current_password)
  end

end
