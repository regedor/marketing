class EmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_email, only: [ :edit, :update, :destroy ]

  # POST /people/:person_id/emails
  def create
    @email = @person.emails.new(email_params)
    # @email.is_active = true if @email.current

    if @email.save
      redirect_to person_path(@person), notice: "Email was successfully created."
    else
      error_messages = @email.errors.full_messages.join(", ")
      redirect_back(fallback_location: person_path(@person), alert: "Failed to create email: #{error_messages}")
    end
  end

  # PATCH /people/:person_id/emails/:id
  def update
    if @email.update(email_params)
      redirect_to person_path(@person), notice: "Email was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/:person_id/emails/:id
  def destroy
    @email.destroy
    redirect_back(fallback_location: person_path(@person),  notice: "Email was successfully deleted.")
  end

  private
    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @person.organization.id
    end

    def email_params
      params.require(:email).permit(:email, :current, :is_active)
    end

    def set_data
      @person = Person.find(params[:person_id])
    end

    def set_email
      @email = @person.emails.find(params[:id])
    end
end
