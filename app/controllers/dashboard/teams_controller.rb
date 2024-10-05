# app/controllers/teams_controller.rb
class Dashboard::TeamsController < ApplicationController
  def create
    @organization = Organization.find(params[:organization_id])
    @team = @organization.teams.new(team_params)

    if @team.save
      redirect_to dashboard_organization_path(@organization), notice: "Team was successfully created."
    else
      render @organization
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
