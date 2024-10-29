class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_companies, only: [ :index ]
  before_action :set_company, only: [ :show, :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :show, :edit, :update, :destroy ]

  # GET /company
  def index
  end

  def new
    @company = Company.new()
  end

  # GET /company/:id
  def show
    workers = @company.personcompanies.map { |pc| pc.person }
    @new_company_note = @company.companynotes.new
    @new_worker = @company.personcompanies.new
    @new_workers = Person.where(organization: current_user.organization).reject { |p| workers.include?(p) }
  end

  # POST /company
  def create
    @company = Company.new(company_params)
    @company.organization = current_user.organization

    if @company.save
      redirect_to company_path(@company), notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET/company/:id/edit
  def edit
  end

  # PATCH/company/:id
  def update
    if @company.update(company_params)
      redirect_to company_path(@company), notice: "Company was successfully updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE/company/:id
  def destroy
    @company.destroy
    redirect_to companies_path, notice: "Company was successfully deleted."
  end

  private

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @company.organization.id
    end

    def company_params
      params.require(:company).permit(:name, :employers_min, :employers_max, :phone_number, :url_site)
    end

    def set_companies
      @companies = Company.where(organization: current_user.organization)
    end

    def set_company
      @company = Company.find(params[:id])
    end
end
