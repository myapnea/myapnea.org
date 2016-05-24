# frozen_string_literal: true

# Allows Devise to respond to JSON authentication
class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create]
  layout 'simple'
end
