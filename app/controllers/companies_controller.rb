class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_companies, only: [ :index ]
  before_action :set_company, only: [ :show, :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :show, :edit, :update, :destroy ]

  # GET /companies
  def index
  end

  # GET /companies/new
  def new
    @company = Company.new()
  end

  # GET /companies/:id
  def show
    company_notes = @company.companynotes.map { |cn| { id: cn.id, note: cn.note, type: "company", author: cn.user.email, to: @company.name, datetime: cn.created_at, link: company_path(@company) } }
    person_company_notes =  @company.personcompanies.select { |pc| pc.person.is_private == false || pc.person.user == current_user }.map { |pc| pc.person.personnotes }.flatten.map { |pn| { id: pn.id, note: pn.note, type: "person", to: pn.person.name, link: person_path(pn.person), author: pn.user.email,  datetime: pn.created_at } }
    @notes = (company_notes + person_company_notes).sort { |a, b| b[:datetime] <=> a[:datetime] }
    workers = @company.personcompanies.map { |pc| pc.person }
    @new_company_note = @company.companynotes.new
    @new_person_company = @company.personcompanies.new
    @new_company_link = @company.companylinks.new
    # @people = Person.where(organization: current_user.organization).reject { |p| workers.include?(p) }.reject{ |p| p.is_private && p.user != current_user }
    @people = Person.where(organization: current_user.organization)
                .where.not(id: workers.pluck(:id))
                .where("is_private = ? OR user_id = ?", false, current_user.id)
  end

  # POST /companies
  def create
    @company = Company.new(company_params)

    if !url?(params[:company][:url_site]) || !url?(params[:company][:linkedin_link])
      flash[:alert] = "Not a valid URL"
      render :new, status: :unprocessable_entity
      return
    end

    @company.organization = current_user.organization
    update_min_max_employers

    if @company.save
      redirect_to company_path(@company), notice: "Company was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /companies/:id/edit
  def edit
  end

  # PATCH /companies/:id
  def update
    if !url?(params[:company][:url_site]) || !url?(params[:company][:linkedin_link])
      redirect_to edit_company_path(@company),  alert: "Not a valid URL"
      return
    end

    update_min_max_employers

    if @company.update(company_params)
      redirect_to company_path(@company), notice: "Company was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:id
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

    def url?(string)
      if string.nil?
        false
      elsif string.empty?
         true
      else
        begin
          uri = URI.parse(string)
          uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        rescue URI::InvalidURIError
          false
        end
      end
    end
end
