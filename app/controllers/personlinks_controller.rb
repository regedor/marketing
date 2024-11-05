class PersonlinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person
  before_action :check_organization!
  before_action :set_personlink, only: [ :destroy_content ]

  # POST /people/:person_id/personlinks/:id/create_content
  def create
    @personlink = @person.personlinks.new(personlinks_params)

    if !url?(params[:personlink][:link])
      redirect_to person_path(@person),  alert: "Not a valid URL"
      return
    end

    begin
      if @personlink.save
        redirect_to person_path(@person), notice: "Entry was successfully updated."
      else
        redirect_to person_path(@person), alert: "Failed to add entry."
      end
    rescue ActiveRecord::RecordNotUnique
      redirect_to person_path(@person), alert: "Entry already exists for this person."
    end
  end

  # DELETE /people/:person_id/personlinks/:id/destroy_content
  def destroy_content
    if @personlink.destroy
      redirect_to person_path(@person), notice: "Content removed successfully."
    else
      redirect_to person_path(@person), alert: "Failed to remove content."
    end
  end

  private

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @person.organization.id
    end

    def set_person
      @person = Person.find(params[:person_id])
    end

    def set_personlink
      @personlink = @person.personlinks.find_by(name: params[:name])
    end


    def personlinks_params
      params.require(:personlink).permit(:name, :link)
    end

    def url?(string)
      uri = URI.parse(string)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end
end
