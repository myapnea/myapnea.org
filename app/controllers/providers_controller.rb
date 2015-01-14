class ProvidersController < ApplicationController
  layout 'layouts/cleantheme'

  #before_action :authenticate_user!
  before_action :authenticate_provider

  def provider

  end

  protected


  def authenticate_provider
    raise Authority::SecurityViolation.new(current_user, 'act as provider', action_name) unless current_user.can?(:act_as_provider)

  end


end
