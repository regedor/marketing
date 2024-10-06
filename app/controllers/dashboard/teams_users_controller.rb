class Dashboard::TeamsUsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  before_action :authorize_leader!

  def create
    @teams_user = TeamsUser.new(teams_user_params)
    @teams_user.user = @user

    if @teams_user.save
      redirect_to dashboard_user_path(@user), notice: "Team successfully added."
    else
      redirect_to dashboard_user_path(@user), alert: "Failed to add team."
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def teams_user_params
      params.require(:teams_user).permit(:team_id)
    end

    def authorize_leader!
      redirect_to root_path, alert: "Access Denied" unless current_user.Admin? || current_user.Leader?
    end
end
