class LeadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pipeline
  before_action :check_organization!
  before_action :set_companies
  before_action :set_lead, only: %i[ show edit update destroy create_content destroy_content ]

  # GET /leads/1 or /leads/1.json
  def show
    @new_lead_note = @lead.leadnotes.new
  end

  # GET /leads/new
  def new
    @lead = Lead.new
  end

  # GET /leads/1/edit
  def edit
  end

  # POST /leads or /leads.json
  def create
    @lead = @pipeline.leads.new(lead_params)

    if @lead.save
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Lead was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leads/1 or /leads/1.json
  def update
    if @lead.update(lead_params)
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Lead was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /leads/1 or /leads/1.json
  def destroy
    @lead.destroy!
    redirect_to pipelines_path, notice: "Lead was successfully destroyed."
  end

  def create_content
    key = params[:key]
    value = params[:value]
    @lead.content[key] = value
    if @lead.save
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Entrery was successfully updated."
    else
      redirect_to pipeline_lead_path(@pipeline, @lead), alert: "Failed to add entery."
    end
  end

  def destroy_content
    key = params[:key]
    @lead.content.delete(key)
    if @lead.save
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Content removed successfully."
    else
      redirect_to pipeline_lead_path(@pipeline, @lead), alert:  "Failed to remove content."
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lead_params
      params.require(:lead).permit(:name, :start_date, :end_date, :company_id)
    end

    def set_pipeline
      @pipeline = Pipeline.find(params[:pipeline_id])
    end

    def set_companies
      @companies = Company.where(organization: current_user.organization)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @pipeline.organization_id
    end
end
