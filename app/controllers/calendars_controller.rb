class CalendarsController < BaseController
  before_action :authenticate_user!
  before_action :set_calendars
  before_action :set_calendar, only: [ :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :edit, :update, :destroy ]

  # GET /calendars
  def index
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
    pcids = params[:calendar_ids].present? ? params[:calendar_ids].map { |id| id.to_i } : []
    selected_calendar_ids = pcids.empty? ? @calendars.map { |c| c.id } : @calendars.select { |c| pcids.include?(c.id) }.map { |c| c.id }

    @only_1 = selected_calendar_ids.length == 1 ? selected_calendar_ids.first : nil

    @posts = Post.where(calendar_id: selected_calendar_ids).where(
      publish_date: @start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week
    )

    @default_attachments = @posts.map do |post|
      default_perspective = post.perspectives.find_by(socialplatform: nil)
      attachments = default_perspective&.attachments.where.not(type_content: "cloud")
        .select(:id, :filename, :type_content, :perspective_id, :status, :attachment_id)

      original_attachments = attachments.reject { |attach| attach.is_preview? }

      default_attachment = original_attachments&.first
      {
        post_id: post.id,
        id: default_attachment&.id,
        filename: default_attachment&.filename,
        preview_url: default_attachment&.preview_image_url
      }
    end
    @attachments_by_post_id = @default_attachments.index_by { |attachment| attachment[:post_id] }

    @permitted_params = permitted_params
  end



  def new
    @calendar = current_organization.calendars.new
  end

  # POST /calendars
  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.organization = current_organization

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
    @calendar.organization = current_organization
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

  private

  def set_calendars
    @calendars = Calendar.where(organization: current_organization).to_a

    if current_organization.slug == "medgical"
      regedor = Organization.find_by(slug: "regedor-creations")
      medgical_calendar = Calendar.find_by(name: "Medgical", organization_id: regedor.id)
      @calendars << medgical_calendar
    end
  end

  def set_calendar
    @calendar = Calendar.find(params[:id])
  end

  def calendar_params
    params.require(:calendar).permit(:name)
  end

  def check_organization!
    redirect_to root_path, alert: "Access Denied" unless current_organization.id == @calendar.organization_id
  end

  def permitted_params
    params.permit(:start_date, calendar_ids: [])
  end
end
