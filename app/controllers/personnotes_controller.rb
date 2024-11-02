class PersonnotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_note, only: [ :edit, :update, :destroy ]
  before_action :check_leader!, only: [ :destroy ]
  before_action :check_author!, only: [ :edit, :update ]

  # POST /people/:person_id/personnotes
  def create
    @note = @person.personnotes.new(personnote_params)
    @note.user_id = current_user.id

    if @note.save
      redirect_back(fallback_location: person_path(@person), notice: "Note was successfully created.")
    else
      error_messages = @note.errors.full_messages.join(", ")
      redirect_back(fallback_location: person_path(@person), alert: "Failed to create note: #{error_messages}")
    end
  end

  # GET /people/:person_id/personnotes/:id/edit
  def edit
  end

  # PATCH /people/:person_id/personnotes/:id
  def update
    if @note.update(personnote_params)
      redirect_to person_path(@person), notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/:person_id/personnotes/:id
  def destroy
    @note.destroy
    redirect_back(fallback_location: person_path(@person),  notice: "Note was successfully deleted.")
  end

  private
    def set_data
      @person = Person.find(params[:person_id])
    end

    def set_note
      @note = @person.personnotes.find(params[:id])
    end

    def personnote_params
      params.require(:personnote).permit(:note, :person_id)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @person.organization.id
    end

    def check_author!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user == @note.user
    end

    def check_leader!
      check_author! unless @current_user.isLeader
    end
end
