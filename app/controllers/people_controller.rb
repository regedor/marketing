class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :set_people, only: [ :index ]
  before_action :set_person, only: [ :show, :edit, :update, :destroy ]

  # GET /people
  def index
  end

  # GET /people/:id
  def show
    @new_email = @person.emails.new
    @new_phone_number = @person.phonenumbers.new
    @new_person_note = @person.personnotes.new
  end

  # POST /people
  def create
    @person = Person.new(person_params)
    @person.organization = current_user.organization
    @person.user = current_user

    if @person.save
      redirect_to person_path(@person), notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET/people/:id/edit
  def edit
  end

  # PATCH/people/:id
  def update
    if @person.update(person_params)
      redirect_to person_path(@person), notice: "Person was successfully updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE/people/:id
  def destroy
    @person.destroy
    redirect_to people_path, notice: "Person was successfully deleted."
  end

  private

    def person_params
      params.require(:person).permit(:name, :birthday, :is_private)
    end

    def set_person
      @person = Person.find(params[:id])
    end

    def set_people
      @people = Person.where(organization: current_user.organization)
    end
end
