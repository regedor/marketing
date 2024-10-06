class Dashboard::TeamsController < ApplicationController
  before_action :set_organization
  before_action :authenticate_user!
  before_action :authorize_leader!
  before_action :authorized_organization!, only: %i[ create ]

  def create
    @team = @organization.teams.new(team_params)
    respond_to do |format|
      if @team.save
        format.html { redirect_to dashboard_organization_path(@organization), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render "dashboard/organizations/show", locals: { organization: @organization }, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      respond_to do |format|
        format.html { redirect_to dashboard_organization_path(@organization), status: :see_other, notice: "Team was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to dashboard_organization_path(@organization), status: :unprocessable_entity, alert: "Failed to destroy the team." }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_organization
      @organization = Organization.find(params[:organization_id])
    end

    def team_params
      params.require(:team).permit(:name)
    end

    def authorize_leader!
      redirect_to root_path, alert: "Access Denied" unless current_user.Admin? || current_user.Leader?
    end

    def authorized_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.Admin? || current_user.organization == Organization.find(params[:organization_id])
    end
end
