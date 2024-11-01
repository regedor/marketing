class PersoncompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person, only: [ :destroy_by_person, :destroy_by_company, :create_by_person, :update_is_working_by_company, :update_is_working_by_person  ]
  before_action :set_company, only: [ :destroy_by_company, :destroy_by_person, :create_by_company, :update_is_working_by_company, :update_is_working_by_person  ]
  before_action :set_personcompany, only: [ :destroy_by_person, :destroy_by_company, :update_is_working_by_company, :update_is_working_by_person ]
  before_action :check_organization_by_person!, only: [ :destroy_by_person, :create_by_person, :update_is_working_by_person ]
  before_action :check_organization_by_company!, only: [ :destroy_by_company, :create_by_company, :update_is_working_by_company ]

  # POST /personcompanies/person/:person_id
  def create_by_person
    @personcompany = Personcompany.new(personcompany_params_by_person)
    @personcompany.person = @person
    create person_path(@person)
  end

  # POST /personcompanies/company/:company_id
  def create_by_company
    @personcompany = Personcompany.new(personcompany_params_by_company)
    @personcompany.company = @company
    create company_path(@company)
  end

  # PATCH /personcompanies/company/:person_id/:company_id
  def update_is_working_by_company
    update_is_working(company_path(@company))
  end

  # PATCH /personcompanies/person/:person_id/:company_id
  def update_is_working_by_person
    update_is_working(person_path(@person))
  end

  # DELETE /personcompanies/person/:person_id/:company_id
  def destroy_by_person
    destroy(person_path(@person))
  end

  # DELETE /personcompanies/company/:person_id/:company_id
  def destroy_by_company
    destroy(company_path(@company))
  end

  private

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @company.organization.id
    end

    def personcompany_params_by_person
      params.require(:personcompany).permit(:is_working, :is_my_contact, :company_id, )
    end

    def personcompany_params_by_company
      params.require(:personcompany).permit(:is_working, :is_my_contact, :person_id, )
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

    def destroy(path)
      @personcompany.destroy
      redirect_to path, notice: "The person company was successfully deleted."
    end

    def update_is_working(path)
      @personcompany.is_working = !@personcompany.is_working
      if @personcompany.save
        redirect_to path,  notice: "Person Company was successfully created."
      else
        error_messages = @personcompany.errors.full_messages.join(", ")
        redirect_back(fallback_location: path, alert: "Failed: #{error_messages}")
      end
    end

    def create(path)
      if @personcompany.save
        redirect_to path,  notice: "Person Company was successfully created."
      else
        error_messages = @personcompany.errors.full_messages.join(", ")
        redirect_back(fallback_location: path, alert: "Failed: #{error_messages}")
      end
    end
end
