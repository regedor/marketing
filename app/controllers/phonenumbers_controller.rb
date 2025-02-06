class PhonenumbersController < BaseController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_phonenumber, only: [ :edit, :update, :destroy ]

  # POST /people/:person_id/phonenumbers
  def create
    @phonenumber = @person.phonenumbers.new(phonenumber_params)

    if @phonenumber.save
      redirect_to person_path(@person), notice: "Phonenumber was successfully created."
    else
      error_messages = @phonenumber.errors.full_messages.join(", ")
      redirect_back(fallback_location: person_path(@person), alert: "Failed to create phonenumber: #{error_messages}")
    end
  end

  # PATCH /people/:person_id/phonenumbers/:id
  def update
    if @phonenumber.update(phonenumber_params)
      redirect_to person_path(@person), notice: "Phonenumber was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/:person_id/phonenumbers/:id
  def destroy
    @phonenumber.destroy
    redirect_back(fallback_location: person_path(@person),  notice: "Phonenumber was successfully deleted.")
  end

  private
    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @person.organization.id
    end

    def phonenumber_params
      params.require(:phonenumber).permit(:number, :current, :is_active)
    end

    def set_data
      @person = Person.find(params[:person_id])
    end

    def set_phonenumber
      @phonenumber = @person.phonenumbers.find(params[:id])
    end
end
