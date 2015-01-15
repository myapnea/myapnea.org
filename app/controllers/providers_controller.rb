class ProvidersController < ApplicationController
  layout 'layouts/cleantheme'

  before_action :authenticate_user!
  before_action :authenticate_provider


  def profile

  end

  def update

    @provider = Provider.find(current_user.id)

    if @provider.update(provider_params)
      redirect_to provider_profile_path, notice: "Your account settings have been successfully changed."
    else
      render :profile
    end
  end

  protected


  def authenticate_provider
    raise Authority::SecurityViolation.new(current_user, 'act as provider', action_name) unless current_user.can?(:act_as_provider)

  end

  def provider_params
    params.required(:provider).permit(:provider_name, :welcome_message, :photo)
  end

end
