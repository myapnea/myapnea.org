# frozen_string_literal: true

# Allows Devise to respond to JSON authentication
class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token, only: [:create]
  layout 'simple'
end
