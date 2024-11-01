class PersonlinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person
  before_action :check_organization!
  before_action :set_personlink, only: [:create_content, :destroy_content]

  # POST /people/:person_id/personlinks/:id/create_content
  def create_content
    key = params[:key]
    value = params[:value]

    # Add the key-value pair to the content JSONB field
    @personlink.content[key] = value
    if @personlink.save
      redirect_to person_path(@person), notice: "Entry was successfully updated."
    else
      redirect_to person_path(@person), alert: "Failed to add entry."
    end
  end

  # DELETE /people/:person_id/personlinks/:id/destroy_content
  def destroy_content
    key = params[:key]
    @personlink.content.delete(key)
    if @personlink.save
      redirect_to person_path(@person), notice: "Content removed successfully."
    else
      redirect_to person_path(@person), alert: "Failed to remove content."
    end
  end

  private

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @person.organization.id
    end

    def set_person
      @person = Person.find(params[:person_id])
    end

    def set_personlink
      @personlink = @person.personlinks.find(params[:id])
    end
end
