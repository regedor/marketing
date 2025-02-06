class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :set_current_member
  before_action :set_sidebar_pipelines

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  attr_reader :current_member, :current_administrator, :current_organization

  helper_method :current_user
  helper_method :current_member
  helper_method :current_administrator
  helper_method :current_organization

  private

  def set_sidebar_pipelines
    if current_user
      @sidebar_pipelines = Pipeline.where(organization: current_user.organization)
    end
  end

  def set_current_member
    @current_member = current_user&.member
  end
end
