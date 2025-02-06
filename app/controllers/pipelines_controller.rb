class PipelinesController < BaseController
  before_action :authenticate_user!
  before_action :set_pipelines
  before_action :set_pipeline, only: %i[ show edit update destroy ]
  before_action :check_organization!, only: %i[ show edit update destroy ]
  before_action :check_leader!, only: %i[ new create edit update destroy ]

  # GET /pipeline/:pipeline_id
  def show; end

  # GET /pipelines/new
  def new
    @pipeline = Pipeline.new
  end

  # GET /pipeline/:pipeline_id/edit
  def edit
    set_form_params
  end

  # POST /pipelines
  def create
    @pipeline = Pipeline.new(pipeline_params)
    @pipeline.organization = current_member.organization

    if @pipeline.save
      redirect_to pipeline_path(@pipeline), notice: "Pipeline was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH /pipeline/:pipeline_id
  def update
    if @pipeline.update(pipeline_params)
      redirect_to pipeline_path(@pipeline), notice: "Pipeline was successfully updated."
    else
      set_form_params
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pipeline/:pipeline_id
  def destroy
    @pipeline.destroy!
    redirect_to dashboard_path, status: :see_other, notice: "Pipeline was successfully destroyed."
  end

  # GET /pipelines/:pipeline_id/selector
  def selector
  end

  # POST /pipelines/:pipeline_id/select_pipeline
  def select_pipeline
    if params[:pipeline][:pipeline_id].present?
      redirect_to new_pipeline_lead_path(Pipeline.find(params[:pipeline][:pipeline_id]))
    else
      redirect_to selector_pipelines_path, alert: "Select a pipeline."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pipeline
      @pipeline = Pipeline.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pipeline_params
      params.require(:pipeline).permit(:name, :to_people)
    end

    def set_pipelines
      @pipelines = Pipeline.where(organization: current_member.organization)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_member&.organization_id == @pipeline.organization_id
    end

    def check_leader!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_member&.isLeader
    end

    def set_form_params
      @new_pipeattribute = @pipeline.pipeattributes.new
      @new_stage = @pipeline.stages.new
      @indexs = @pipeline.stages.order(:index).map { |s| s.index }
    end
end
