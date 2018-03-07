# frozen_string_literal: true

# Override for devise confirmations controller.
class ConfirmationsController < Devise::ConfirmationsController
  layout "layouts/full_page"
end
