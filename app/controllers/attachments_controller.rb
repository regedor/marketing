class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_attachment, only: [ :show, :edit, :update, :destroy, :download, :like, :dislike, :update_status ]

  # POST /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments
  def create
    @attachment = @perspective.attachments.new(attachment_params)

    if params[:attachment][:content].present?
      @attachment.content = params[:attachment][:content].read
      @attachment.filename = generate_unique_filename(params[:attachment][:content].original_filename)
      @attachment.type_content = params[:attachment][:content].content_type
    else
      @attachment.type_content = "cloud"
    end

    if @attachment.save
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment was successfully created."
    else
      error_messages = @attachment.errors.full_messages.join(", ")
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective),  alert: "Failed to create attachment: #{error_messages}"
    end
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def show
    send_data @attachment.content, type: @attachment.type_content, disposition: "inline"
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def update
    data = attachment_params
    data["filename"] = generate_unique_filename(data["filename"])
    if @attachment.update(data)
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
    if @attachment.type_content == "cloud"
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "The Attachment is a url for google drive."
    else
      send_data @attachment.content, filename: @attachment.filename,  type: @attachment.type_content, disposition: "attachment"
    end
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/update_status
  def update_status
    @attachment.update(attachment_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Attachment status updated."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/like
  def like
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.aproved = !@attachmentcounter.aproved
    @attachmentcounter.rejected = false
    save_counter(@attachmentcounter)
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/dislike
  def dislike
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.aproved = false
    @attachmentcounter.rejected = !@attachmentcounter.rejected
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
        redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Reaction was successfully saved."
      else
        error_message = attachmentcounter.errors.full_messages.join(", ")
        puts error_message
        redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "There was an error saving the reaction." + error_message
      end
    end
    def attachment_params_status
      params.require(:attachment).permit(:status)
    end

    def generate_unique_filename(filename)
      base_name = File.basename(filename, ".*")
      extension = File.extname(filename)
      counter = 1
      unique_filename = filename
      attachments_post = @post.perspectives.map { |p| p.attachments }.flatten.reject { |a| @attachment.present? ? a.id == @attachment.id : false }.map { |a| a.filename }
      while attachments_post.include?(unique_filename)
        unique_filename = "#{base_name} (#{counter})#{extension}"
        counter += 1
      end
      unique_filename
    end
end
