class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :set_sidebar_pipelines

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private
  def set_sidebar_pipelines
    if current_user
      @sidebar_pipelines = Pipeline.where(organization: current_user.organization)
    end
  end
end
