class StagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pipeline
  before_action :set_last_stages
  before_action :check_organization!
  before_action :set_stage, only: [ :edit, :update, :destroy, :update_index_stage ]

  # POST /pipeline/:pipeline_id/stage
  def create
    if @last_stage
      @last_stage.update(is_final: false)
    end
    @stage = @pipeline.stages.new(stage_params)
    @stage.is_final = true
    @stage.index = @pipeline.stages.length

    if @stage.save
      redirect_to pipeline_path(@pipeline), notice: "Stage was successfully created."
    else
      error_messages = @stage.errors.full_messages.join(", ")
      redirect_back(fallback_location: pipeline_path(@pipeline), alert: "Failed to create Stage: #{error_messages}")
    end
  end

  # PATCH /pipeline/:pipeline_id/stage/:stage_id/edit
  def edit
  end

  # PATCH /pipeline/:pipeline_id/stage/:stage_id
  def update
    if @stage.update(stage_params)
      redirect_to pipeline_path(@pipeline), notice: "Stage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH /pipeline/:pipeline_id/stage/:stage_id/update_index_stage
  def update_index_stage
    received_index = params[:stage][:index].to_i
    if received_index < @stage.index
      change_index(@stages_before.reject { |stage| stage.index < received_index }, +1)
    elsif received_index > @stage.index
      change_index(@stages_after.reject { |stage| stage.index > received_index }, -1)
    end
    if @stage == @last_stage && @sndlast_stage
      swap_is_final(@stage, @sndlast_stage)
    elsif received_index == @last_index
      swap_is_final(@last_stage, @stage)
    end
    if @stage.update(index_stage_params)
      redirect_to pipeline_path(@pipeline), notice: "Stage was successfully updated."
    else
      redirect_to pipeline_path(@pipeline), alert: "Error"
    end
  end

  # DELETE /pipeline/:pipeline_id/stage/:stage_id
  def destroy
    if @last_stage == @stage && @sndlast_stage
      @sndlast_stage.update(is_final: true)
    end
    change_index(@stages_after, -1)
    @stage.destroy!
    redirect_to pipeline_path(@pipeline), notice: "Stage was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stage
      @stage = @pipeline.stages.find(params[:id] || params[:stage_id])
      @stages_before = @ordered.where("index < ?", @stage.index)
      @stages_after = @ordered.where("index > ?", @stage.index)
      @last_index = @ordered.last ? @ordered.last.index : 0
    end

    def set_pipeline
      @pipeline = Pipeline.find(params[:pipeline_id])
      @ordered = @pipeline.stages.order(:index)
    end

    def stage_params
      params.require(:stage).permit(:name)
    end

    def index_stage_params
      params.require(:stage).permit(:index)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @pipeline.organization_id
    end

    def set_last_stages
      if @ordered.length > 0
        @last_stage = @ordered.last
      end
      if @ordered.length > 1
        @sndlast_stage = @ordered[@ordered.length - 2]
      end
    end

    def change_index(stages, inc)
      stages.each { |stage| stage.update(index: stage.index+inc) }
    end

    def swap_is_final(now_final, end_final)
      end_final.update(is_final: true)
      now_final.update(is_final: false)
    end
end
