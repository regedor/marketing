class Dashboard::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_leader!
  before_action :authorized_organization! , only: %i[ create ]

  def create
    @organization = Organization.find(params[:organization_id])
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

  private
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
