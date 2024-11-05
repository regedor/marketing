class LeadcontentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_leadcontent, only: [ :edit, :update ]

  # GET /pipeline/:pipeline_id/leads/:lead_id/leadcontent/:id/edit
  def edit
  end

  # PATCH /pipeline/:pipeline_id/leads/:lead_id/leadcontent/:id
  def update
    if @leadcontent.update(leadcontent_params)
      redirect_to pipeline_lead_path(@pipeline, @lead), notice: "Stage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leadcontent
      @leadcontent = @lead.leadcontents.find(params[:id])
    end

    def set_data
      @pipeline = Pipeline.find(params[:pipeline_id])
      @lead = Lead.find(params[:lead_id])
    end

    def leadcontent_params
      params.require(:leadcontent).permit(:value)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @pipeline.organization_id
    end
end
