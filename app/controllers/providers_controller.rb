class ProvidersController < ApplicationController
  layout 'layouts/cleantheme'

  before_action :set_provider,              only: [ :show ] # , :edit, :update, :destroy
  before_action :redirect_without_provider, only: [ :show ] # , :edit, :update, :destroy


  def index
    @providers = User.where(user_type: 'provider').where.not(slug: nil, provider_name: nil).page(params[:page]).per( 8 )
  end


  def new
    @provider = User.new(user_type: 'provider', welcome_message: 'Welcome to my page!')
  end

  # before_action :authenticate_user!
  # before_action :authenticate_provider


  # def profile

  # end

  # def update

  #   @provider = Provider.find(current_user.id)

  #   if @provider.update(provider_params)
  #     redirect_to provider_profile_path, notice: "Your account settings have been successfully changed."
  #   else
  #     render :profile
  #   end
  # end

  protected

    def set_provider
      @provider = User.current.where(user_type: 'provider').find_by_slug(params[:id])
    end

    def redirect_without_provider
      empty_response_or_root_path(providers_path) unless @provider
    end



  # def authenticate_provider
  #   raise Authority::SecurityViolation.new(current_user, 'act as provider', action_name) unless current_user.can?(:act_as_provider)

  # end

  # def provider_params
  #   params.required(:provider).permit(:provider_name, :welcome_message, :photo)
  # end

end
