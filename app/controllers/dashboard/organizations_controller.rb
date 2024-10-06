class Dashboard::OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_leader!
  before_action :authorize_admin, only: %i[ new create destroy ]
  before_action :authorized_organization!

  # GET /dashboard/organizations/1 or /dashboard/organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    @team = Team.new
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /dashboard/organizations/1/edit
  def edit
  end

  # POST /dashboard/organizations or /dashboard/organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to dashboard_organization_path(@organization), notice: "Organization was successfully created." }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboard/organizations/1 or /dashboard/organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to dashboard_organization_path(@organization), notice: "Organization was successfully updated." }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboard/organizations/1 or /dashboard/organizations/1.json
  def destroy
    @organization.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_path, status: :see_other, notice: "Organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name)
    end

    def authorize_admin
      redirect_to root_path, alert: "Access Denied" unless current_user.Admin?
    end

    def authorize_leader!
      redirect_to root_path, alert: "Access Denied" unless current_user.Admin? || current_user.Leader?
    end

    def authorized_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.Admin? || current_user.organization == Organization.find(params[:id])
    end
end
