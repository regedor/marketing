class StagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pipeline
  before_action :check_organization!
  before_action :set_stage, only: [ :edit, :update, :destroy ]

  # POST /leads or /leads.json
  def create
    @stage = @pipeline.stages.new(stage_params)

    if @stage.save
      redirect_to pipeline_path(@pipeline), notice: "Stage was successfully created."
    else
      error_messages = @stage.errors.full_messages.join(", ")
      redirect_back(fallback_location: pipeline_path(@pipeline), alert: "Failed to create Stage: #{error_messages}")
    end
  end

  def edit
  end

  # PATCH/PUT /leads/1 or /leads/1.json
  def update
    if @stage.update(stage_params)
      redirect_to pipeline_path(@pipeline), notice: "Stage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /leads/1 or /leads/1.json
  def destroy
    @stage.destroy!
    redirect_to pipeline_path(@pipeline), notice: "Stage was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stage
      @stage = @pipeline.stages.find(params[:id])
    end

    def set_pipeline
      @pipeline = Pipeline.find(params[:pipeline_id])
    end

    def stage_params
      params.require(:stage).permit(:name, :is_final, :index)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @pipeline.organization_id
    end
end
