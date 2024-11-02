class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_leader!

  def index
    @users = User.where(organization_id: current_user.organization_id)
    @calendars = Calendar.where(organization_id: current_user.organization_id)
  end

  private
    def authorize_leader!
      redirect_to root_path, alert: "Access Denied" unless current_user.isLeader
    end
end
