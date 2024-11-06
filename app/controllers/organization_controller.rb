class OrganizationController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_leader!
  before_action :set_organization, only: [:update]
  before_action :check_organization!
  
  # PATCH /organization/:id
  def update
    if @organization.update(organization_params)
      redirect_to redirect_to dashboard_path, notice: "Organization was successfully updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_organization
      @organization = Organization.find(params[:id])
    end
    
    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization == @organization
    end

    def authorize_leader
      redirect_to root_path, alert: "Access Denied" unless current_user.isLeader
    end

    def organization_params
      params.require(:organization).permit(:slack_workspace_token, :slack_channel)
    end

end