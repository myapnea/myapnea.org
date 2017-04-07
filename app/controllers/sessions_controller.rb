# frozen_string_literal: true

# Session controller stub.
class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create]
end
