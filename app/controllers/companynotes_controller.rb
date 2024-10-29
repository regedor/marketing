class CompanynotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_note, only: [ :edit, :update, :destroy ]
  before_action :check_author!, only: [ :edit, :update, :destroy ]

  # POST /company/:company_id/companynotes
  def create
    @note = @company.companynotes.new(companynote_params)
    @note.user_id = current_user.id

    if @note.save
      redirect_back(fallback_location: company_path(@company), notice: "Note was successfully created.")
    else
      error_messages = @note.errors.full_messages.join(", ")
      redirect_back(fallback_location: company_path(@company), alert: "Failed to create note: #{error_messages}")
    end
  end

  # GET /company/:company_id/companynotes/:id/edit
  def edit
  end

  # PATCH /company/:company_id/companynotes/:id
  def update
    if @note.update(companynote_params)
      redirect_to company_path(@company), notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /company/:company_id/companynotes/:id
  def destroy
    @note.destroy
    redirect_back(fallback_location: company_path(@company),  notice: "Note was successfully deleted.")
  end

  private
    def set_data
      @company = Company.find(params[:company_id])
    end

    def set_note
      @note = @company.companynotes.find(params[:id])
    end

    def companynote_params
      params.require(:companynote).permit(:note)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @company.organization.id
    end

    def check_author!
      redirect_to root_path, alert: "Access Denied" unless current_user == @note.user
    end
end
