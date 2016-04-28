class SessionsController < Devise::SessionsController

  respond_to :json, :js

  skip_before_action :verify_authenticity_token, only: [ :create ]

end
