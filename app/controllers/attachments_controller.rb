class AttachmentsController < BaseController # rubocop:disable Metrics/ClassLength
  include ActionView::RecordIdentifier

  # before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_attachment, only: %i[show edit update destroy download like dislike update_status]

  # POST /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def show
    send_data @attachment.content, type: @attachment.type_content,
      disposition: "inline; filename=#{@attachment.filename}"
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/edit
  def edit; end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    uploaded_files = Array(params[:attachment][:content]).reject(&:blank?)
    attachments = []

    if uploaded_files.any?
      uploaded_files.each do |file|
        next unless file.respond_to?(:read) # Ensure it's a valid uploaded file

        attachment = @perspective.attachments.new
        attachment.content = file.read
        attachment.filename = generate_unique_filename(file.original_filename)
        attachment.type_content = file.content_type

        if attachment.save
          attachment.generate_preview
          attachments << attachment
          LogEntry.create_log("Attachment has been created by #{current_member.email}. [#{attachment.filename}]")
        else
          error_messages = attachment.errors.full_messages.join(", ")
          LogEntry.create_log("#{current_member.email} attempted to create an attachment but failed (error: #{error_messages}).")
        end
      end
    else
      unless url?(params[:attachment][:filename])
        redirect_to calendar_post_perspective_path(@calendar, @post, @perspective, anchor: "attachments_info"),
                  alert: "Not a valid URL"
        return
      end

      attachment = @perspective.attachments.new(type_content: "cloud")

      if attachment.save
        attachments << attachment
        LogEntry.create_log("Cloud attachment created by #{current_member.email}.")
      else
        error_messages = attachment.errors.full_messages.join(", ")
        LogEntry.create_log("#{current_member.email} attempted to create cloud attachment but failed (error: #{error_messages}).")
      end
    end

    if attachments.any?
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective, anchor: dom_id(attachments.first)),
                  notice: "Attachments were successfully created."
    else
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective, anchor: "attachments_info"),
                  alert: "Failed to create attachments."
    end
  end



  # PATCH/PUT /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def update # rubocop:disable Metrics/AbcSize
    data = attachment_params
    if @attachment.type_content == "cloud"
      unless url?(params[:attachment][:filename])
        redirect_to edit_calendar_post_perspective_attachment_path(@calendar, @post, @perspective, @attachment,
          anchor: "attachments_info"), alert: "Not valid URL."
        return
      end
    else
      data["filename"] = generate_unique_filename(data["filename"])
    end
    if @attachment.update(data)
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective, anchor: dom_id(@attachment)),
        notice: "Attachment was successfully updated."
      LogEntry.create_log("Attachment has been updated by #{current_member.email}. [#{attachment_params}]")
    else
      render :edit, status: :unprocessable_entity

      LogEntry.create_log("#{current_member.email} attempted to update attachment but failed (unprocessable_entity). " \
                          "[#{attachment_params}]")
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def destroy
    @attachment.destroy
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective, anchor: "attachments_info"),
      notice: "Attachment was successfully destroyed."
    LogEntry.create_log("Attachment #{@attachment.filename} has been destroyed by #{current_member.email}.")
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/download
  def download
    if @attachment.type_content == "cloud"
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective),
        alert: "The Attachment is a url for google drive."
    else
      send_data @attachment.content, filename: @attachment.filename, type: @attachment.type_content,
        disposition: "attachment"
    end
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/update_status
  def update_status
    @attachment.update(attachment_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective, anchor: dom_id(@attachment)),
      notice: "Attachment status updated."
    LogEntry.create_log("Attachment #{@attachment.id} status has been updated by #{current_member.email}. " \
                        "[#{attachment_params_status}]")
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/like
  def like
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.aproved = !@attachmentcounter.aproved
    @attachmentcounter.rejected = false
    save_counter(@attachmentcounter)

    LogEntry.create_log("Attachment #{@attachment.id} has been liked by #{current_member.email}.")
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/dislike
  def dislike
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.aproved = false
    @attachmentcounter.rejected = !@attachmentcounter.rejected
    save_counter(@attachmentcounter)

    LogEntry.create_log("Attachment #{@attachment.id} has been disliked by #{current_member.email}.")
  end

  private

  def set_data
    @calendar = Calendar.find(params[:calendar_id])
    @post = Post.find(params[:post_id])
    @perspective = Perspective.find(params[:perspective_id])
  end

  def set_attachment
    @attachment = @post.perspectives.map(&:attachments).flatten.select { |a| a.id == params[:id].to_i }.first
  end

  def attachment_params
    params.require(:attachment).permit(:filename)
  end

  def check_organization!
    # return if current_organization.slug == "medgical" && @post.member.organization.slug == "regedor-creations"
    redirect_to root_path, alert: "Access Denied" unless current_member&.organization_id == @calendar.organization.id
  end

  def find_or_initialize_attachmentcounter
    Attachmentcounter.find_or_initialize_by(attachment: @attachment, member: current_member)
  end

  def save_counter(attachmentcounter)
    if attachmentcounter.save
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective,
        anchor: dom_id(attachmentcounter.attachment)), notice: "Reaction was successfully saved."
    else
      error_message = attachmentcounter.errors.full_messages.join(", ")
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective),
        alert: "There was an error saving the reaction. #{error_message}"
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
    attachments = @post.perspectives.map(&:attachments)
    attachments_post = attachments
                       .flatten.reject { |a| @attachment.present? ? a.id == @attachment.id : false }.map(&:filename)
    while attachments_post.include?(unique_filename)
      unique_filename = "#{base_name} (#{counter})#{extension}"
      counter += 1
    end
    unique_filename
  end

  def url?(string)
    uri = URI.parse(string)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
