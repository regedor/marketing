class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendars
  before_action :set_calendar, only: [ :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :edit, :update, :destroy ]

  # GET /calendars
  def index
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
    selected_calendar_ids = params[:calendar_ids] || @calendars.pluck(:id)
    @posts = Post.where(calendar_id: selected_calendar_ids).where(
      publish_date: @start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week
    )
    @permitted_params = permitted_params
  end

  def new
    @calendar = current_user.organization.calendars.new
  end

  # POST /calendars
  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.organization = current_user.organization

    if @calendar.save
      redirect_to dashboard_path, notice: "Calendar was successfully created."

      LogEntry.create_log("Calendar has been created by #{current_user.email}. [#{calendar_params}]")
    else
      render :index, status: :unprocessable_entity

      LogEntry.create_log("Failed to create calendar by #{current_user.email}. [#{calendar_params}]")
    end
  end

  # GET /calendars/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:id
  def update
    @calendar.organization = current_user.organization
    if @calendar.update(calendar_params)
      redirect_to dashboard_path, notice: "Calendar was successfully updated."
    else
      render :edit, status: :unprocessable_entity

      LogEntry.create_log("#{current_user.email} attempted to update calendar (unprocessable_entity). [#{calendar_params}]")
    end
  end

  # DELETE /calendars/:id
  def destroy
    @calendar.destroy
    redirect_to dashboard_path, notice: "Calendar was successfully destroyed."
  end

  def selector
  end

  def select_calendar
    if params[:calendar][:calendar_id].present?
      redirect_to new_calendar_post_path(Calendar.find(params[:calendar][:calendar_id]))
    else
      redirect_to selector_calendars_path, alert: "Select a calendar."
    end
  end

  private

  def set_calendars
    @calendars = Calendar.where(organization: current_user.organization)
  end

  def set_calendar
    @calendar = Calendar.find(params[:id])
  end

  def calendar_params
    params.require(:calendar).permit(:name)
  end

  def check_organization!
    redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization_id
  end

  def permitted_params
    params.permit(:start_date, calendar_ids: [])
  end
end
