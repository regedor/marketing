class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_attachment, only: [:show, :edit, :update, :destroy, :download, :approved, :in_analysis, :rejected, :like, :dislike]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments
  def index
    @attachments = @perspective.attachments
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def show
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/new
  def new
    @attachment = @perspective.attachments.build
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments
  def create
    @attachment = @perspective.attachments.new(attachment_params)
  
    if params[:attachment][:content].present?
      # Read the file data into binary format
      @attachment.content = params[:attachment][:content].read
      @attachment.filename = params[:attachment][:content].original_filename
    end
  
    if @attachment.save
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment was successfully created."
    else
      @attachments = @perspective.attachments
      render "perspectives/show", status: :unprocessable_entity
    end
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/edit
  def edit
    @attachment = @perspective.attachments.find(params[:id])
  end

  # PATCH/PUT /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def update
    if @attachment.update(attachment_params)
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def destroy
    @attachment.destroy
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment was successfully destroyed."
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/download
  def download
    send_data @attachment.content, filename: @attachment.filename,  type: "image/jpeg", disposition: 'attachment'
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/approved
  def approved
    @attachment.update(status: "approved")
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment status updated to Approved."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/in_analysis
  def in_analysis
    @attachment.update(status: "in_analysis")
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment status updated to In Analysis."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/rejected
  def rejected
    @attachment.update(status: "rejected")
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment status updated to Rejected."
  end

  def like
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.aproved = true
    @attachmentcounter.rejected = false
    save_counter(@attachmentcounter)
  end

  def dislike
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.aproved = false
    @attachmentcounter.rejected = true
    save_counter(@attachmentcounter)
  end

  private

    def set_data
      @calendar = Calendar.find(params[:calendar_id])
      @post = Post.find(params[:post_id])
      @perspective = Perspective.find(params[:perspective_id])
    end

    def set_attachment
      @attachment = @perspective.attachments.find(params[:id])
    end

    def attachment_params
      params.require(:attachment).permit(:filename)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def find_or_initialize_attachmentcounter
      Attachmentcounter.find_or_initialize_by(attachment: @attachment, user: current_user)
    end

    def save_counter(attachmentcounter)
      if attachmentcounter.save
        redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Your response was successfully recorded."
      else
        error_message = attachmentcounter.errors.full_messages.join(", ")
        puts error_message
        redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "There was an error recording your response." + error_message
      end
    end
end
