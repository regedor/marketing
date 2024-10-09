class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private
end
