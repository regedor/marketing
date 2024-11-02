class LeadnotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_note, only: [ :edit, :update, :destroy ]
  before_action :check_leader!, only: [ :destroy ]
  before_action :check_author!, only: [ :edit, :update ]

  # POST /pipeline/:pipeline_id/leads/lead_id/leadnotes
  def create
    @note = @lead.leadnotes.new(leadnote_params)
    @note.user_id = current_user.id

    if @note.save
      redirect_back(fallback_location: pipeline_lead_path(@pipeline, @lead), notice: "Note was successfully created.")
    else
      error_messages = @note.errors.full_messages.join(", ")
      redirect_back(fallback_location: pipeline_lead_path(@pipeline, @lead), alert: "Failed to create note: #{error_messages}")
    end
  end

  # GET /pipeline/:pipeline_id/leads/lead_id/leadnotes/leadnote_id/edit
  def edit
  end

  # PATCH /pipeline/:pipeline_id/leads/lead_id/leadnotes/leadnote_id
  def update
    if @note.update(leadnote_params)
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pipeline/:pipeline_id/leads/lead_id/leadnotes/leadnote_id
  def destroy
    @note.destroy
    redirect_back(fallback_location: pipeline_lead_path(@pipeline, @lead),  notice: "Note was successfully deleted.")
  end

  private
    def set_data
      @lead = Lead.find(params[:lead_id])
      @pipeline = Pipeline.find(params[:pipeline_id])
    end

    def set_note
      @note = @lead.leadnotes.find(params[:id])
    end

    def leadnote_params
      params.require(:leadnote).permit(:note)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @pipeline.organization.id
    end

    def check_author!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user == @note.user
    end

    def check_leader!
      check_author! unless @current_user.isLeader
    end
end
