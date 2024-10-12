class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendars
  before_action :set_calendar, only: [ :show, :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :show, :edit, :update, :destroy ]

  # GET /calendars
  def index
    @calendar = Calendar.new
  end

  # GET /calendars/:id
  def show
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  # POST /calendars
  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.organization = current_user.organization

    if @calendar.save
      redirect_to "/calendars", notice: "Calendar was successfully created."
    else
      render :index, status: :unprocessable_entity
    end
  end

  # GET /calendars/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:id
  def update
    @calendar.organization = current_user.organization
    if @calendar.update(calendar_params)
      redirect_to "/calendars", notice: "Calendar was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:id
  def destroy
    @calendar.destroy
    redirect_to calendars_url, notice: "Calendar was successfully destroyed."
  end

  private
    def set_calendars
      @calendars = Calendar.where(organization: current_user.organization)
    end
    # Find the calendar for actions like show, edit, update, destroy
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Strong parameters: Only allow the trusted parameters for calendar
    def calendar_params
      params.require(:calendar).permit(:name)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization_id
    end
end
