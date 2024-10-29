class PersoncompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person, only: [ :destroy_by_person, :destroy_by_company, :create_by_person ]
  before_action :set_company, only: [ :destroy_by_company, :destroy_by_person, :create_by_company ]
  before_action :set_personcompany, only: [ :destroy_by_person, :destroy_by_company ]
  before_action :check_organization_by_person!, only: [ :destroy_by_person, :create_by_person ]
  before_action :check_organization_by_company!, only: [ :destroy_by_company, :create_by_company ]

  # POST /personcompanies/person/:person_id
  def create_by_person
    @personcompanies = Personcompany.new(personcompany_params_by_person)
    @personcompanies.person = @person

    if @personcompanies.save
      redirect_to person_path(@person), notice: "Person Company was successfully created."
    else
      error_messages = @personcompanies.errors.full_messages.join(", ")
      redirect_back(fallback_location: person_path(@person), alert: "Failed: #{error_messages}")
    end
  end

  # POST /personcompanies/company/:company_id
  def create_by_company
    @personcompanies = Personcompany.new(personcompany_params_by_company)
    @personcompanies.company = @company

    if @personcompanies.save
      redirect_to company_path(@company),  notice: "Person Company was successfully created."
    else
      error_messages = @personcompanies.errors.full_messages.join(", ")
      redirect_back(fallback_location: company_path(@company), alert: "Failed: #{error_messages}")
    end
  end

  # DELETE /personcompanies/person/:person_id/:company_id
  def destroy_by_person
    @personcompany.destroy
    redirect_to person_path(@person), notice: "The person company was successfully deleted."
  end

  # DELETE /personcompanies/company/:person_id/:company_id
  def destroy_by_company
    @personcompany.destroy
    redirect_to company_path(@company), notice: "The person company was successfully deleted."
  end

  private

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @company.organization.id
    end

    def personcompany_params_by_person
      params.require(:personcompany).permit(:is_working, :company_id)
    end

    def personcompany_params_by_company
      params.require(:personcompany).permit(:is_working, :person_id)
    end

    def set_personcompany
      @personcompany = Personcompany.find_by(person: @person, company: @company)
    end

    def set_person
      @person = Person.find(params[:person_id])
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def check_organization_by_company!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @company.organization_id
    end

    def check_organization_by_person!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @person.organization_id
    end
end
