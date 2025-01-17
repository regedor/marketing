class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :set_people, only: [ :index ]
  before_action :set_person, only: [ :show, :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :show, :edit, :update, :destroy ]
  before_action :check_leader!, only: [ :destroy ]
  before_action :check_author!, only: [ :show, :edit, :update ]
  before_action :check_owner!, only: [ :update ]

  # GET /people
  def index
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/:id
  def show
    @new_email = @person.emails.new
    @new_phone_number = @person.phonenumbers.new
    @new_person_link = @person.personlinks.new
    @new_person_note = @person.personnotes.new
    @new_person_company = @person.personcompanies.new

    workers = @person.personcompanies.map { |pc| pc.company }
    @companies = Company.where(organization: current_user.organization).reject { |p| workers.include?(p) }
  end

  # POST /people
  def create
    @person = Person.new(person_params)
    @person.organization = current_user.organization
    @person.user = current_user

    if !url?(params[:person][:linkedin_link])
      flash[:alert] = "Not a valid URL"
      render :new, status: :unprocessable_entity
      return
    end

    if @person.save
      redirect_to person_path(@person), notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /people/:id/edit
  def edit
  end

  # PATCH /people/:id
  def update
    if !url?(params[:person][:linkedin_link])
      redirect_to edit_person_path(@person),  alert: "Not a valid URL"
      return
    end

    if @person.update(person_params)
      redirect_to person_path(@person), notice: "Person was successfully updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /people/:id
  def destroy
    @person.destroy
    redirect_to people_path, notice: "Person was successfully deleted."
  end

  private

    def person_params
      params.require(:person).permit(:name, :birthdate, :description, :is_private, :linkedin_link)
    end

    def set_person
      @person = Person.find(params[:id])
    end

    def set_people
      @people = Person.where(organization: current_user.organization)
                      .where("is_private = ? OR user_id = ?", false, current_user.id)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @person.organization_id
    end

    def check_author!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless @person.is_private == false || @person.user == current_user
    end

    def check_leader!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless @person.user == current_user || (@person.is_private == false && current_user.isLeader)
    end

    def check_owner!
      redirect_to request.referrer || root_path, alert: "Access Denied. You cannot change is private flag." unless params[:person][:is_private] == @person.is_private || @person.user == current_user
    end

    def url?(string)
      if string.empty?
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
