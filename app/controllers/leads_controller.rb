class LeadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pipeline
  before_action :set_lead, only: %i[ show edit update destroy ]

  # GET /leads/1 or /leads/1.json
  def show
    @new_lead_note = @lead.leadnotes.new
  end

  # GET /leads/new
  def new
    @lead = Lead.new
    @companies = Company.where(organization: current_user.organization)
  end

  # GET /leads/1/edit
  def edit
    @companies = Company.where(organization: current_user.organization)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lead_params
      params.require(:lead).permit(:name, :content, :start_date, :end_date, :company_id)
    end

    def set_pipeline
      @pipeline = Pipeline.find(params[:pipeline_id])
    end
end
