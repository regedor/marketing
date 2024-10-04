class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private
  
  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
  rescue
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end
  
end
