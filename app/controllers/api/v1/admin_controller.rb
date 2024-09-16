class Api::V1::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization!

  def check_authorization!
    # authorize :admin, :admin?

    if current_user&.email != ENV.fetch('ADMIN_USER_EMAIL') && request.remote_ip != ENV.fetch('ADMIN_USER_IP')
      render json: {
        message: 'User not authorized, only admin can access'
      }.to_json, status: 403
    end
  end
end