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
    company_notes = @company.companynotes.map { |cn| { id: cn.id, note: cn.note, type: "company", author: cn.user.email, to: @company.name, datetime: cn.created_at } }
    person_company_notes =  @company.personcompanies.map { |pc| pc.person.personnotes }.flatten.map { |pn| { id: pn.id, note: pn.note, type: "person", to: pn.person.name, author: pn.user.email,  datetime: pn.created_at } }
    @notes = (company_notes + person_company_notes).sort { |a, b| b[:datetime] <=> a[:datetime] }
    workers = @company.personcompanies.map { |pc| pc.person }
    @new_company_note = @company.companynotes.new
    @new_person_company = @company.personcompanies.new
    @new_company_link = @company.companylinks.new
    @people = Person.where(organization: current_user.organization).reject { |p| workers.include?(p) }
  end

  # POST /company
  def create
    @company = Company.new(company_params)
    update_min_max_employers
    @company.organization = current_user.organization

    if @company.save
      redirect_to company_path(@company), notice: "Company was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET/company/:id/edit
  def edit
  end

  # PATCH/company/:id
  def update
    update_min_max_employers
    if @company.update(company_params)
      redirect_to company_path(@company), notice: "Company was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE/company/:id
  def destroy
    @company.destroy
    redirect_to companies_path, notice: "Company was successfully deleted."
  end

  private

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @company.organization.id
    end

    def company_params
      params.require(:company).permit(:name, :phone_number, :url_site, :linkedin_link, :description)
    end

    def set_companies
      @companies = Company.where(organization: current_user.organization)
    end

    def set_company
      @company = Company.find(params[:id])
    end

    def update_min_max_employers
      if params[:company][:employer_range].present?
        min, max = params[:company][:employer_range].split("-").map(&:to_i)
        @company.employers_min = min
        @company.employers_max = max
      end
    end
end
