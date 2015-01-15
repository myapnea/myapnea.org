class RegistrationsController < Devise::RegistrationsController
  # TODO remove when new layout is default
  layout 'layouts/cleantheme'

  def new




    @provider = Provider.find_by_slug(params[:slug])


    #
    # build_resource({})
    # @validatable = devise_mapping.validatable?
    # if @validatable
    #   @minimum_password_length = resource_class.password_length.min
    # end
    # respond_with self.resource
    #
    super
  end

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

  private

  def sign_up_params
    if params[:user][:type] == "Provider"
      params.require(:user).permit(:first_name, :last_name, :provider_name, :slug, :address_1, :address_2, :city, :state_code, :zip_code, :email, :password, :password_confirmation, :type, :welcome_message)
    else
      params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :provider_name, :provider_id)
    end

  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :year_of_birth, :zip_code, :email, :password, :password_confirmation, :current_password)
  end

end
