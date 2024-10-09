class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_leader!

  def index
    if current_user.isLeader
      @organizations = Organization.all
      @users = User.all
    else
      @users = User.where(organization_id: current_user.organization_id)
    end
  end

  private

  def authorize_leader!
    redirect_to root_path, alert: "Access Denied" unless current_user.isLeader
  end
end
