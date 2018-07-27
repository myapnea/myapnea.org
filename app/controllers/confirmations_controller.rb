# frozen_string_literal: true

# Override for devise confirmations controller.
class ConfirmationsController < Devise::ConfirmationsController
  layout "layouts/full_page"

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    dashboard_path
  end
end
