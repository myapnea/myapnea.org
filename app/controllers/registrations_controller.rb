# frozen_string_literal: true

# Override for devise registrations controller.
class RegistrationsController < Devise::RegistrationsController
  layout "layouts/full_page"
end
