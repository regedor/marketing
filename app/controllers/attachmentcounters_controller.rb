class AttachmentcountersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :set_post
  before_action :set_perspective
  before_action :set_attachment
  before_action :set_attachmentcounter, only: [:edit, :update, :destroy]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:attachment_id/attachmentcounters
  def index
    @attachmentcounters = @attachment.attachmentcounters
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:attachment_id/attachmentcounters/new
  def new
    @attachmentcounter = @attachment.attachmentcounters.build
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:attachment_id/attachmentcounters
  def create
    @attachmentcounter = @attachment.attachmentcounters.build(attachmentcounter_params)
    @attachmentcounter.user = current_user

    if @attachmentcounter.save
      redirect_to [@calendar, @post, @perspective, @attachment], notice: "Attachment counter was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:attachment_id/attachmentcounters/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:attachment_id/attachmentcounters/:id
  def update
    if @attachmentcounter.update(attachmentcounter_params)
      redirect_to [@calendar, @post, @perspective, @attachment], notice: "Attachment counter was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:attachment_id/attachmentcounters/:id
  def destroy
    @attachmentcounter.destroy
    redirect_to [@calendar, @post, @perspective, @attachment], notice: "Attachment counter was successfully destroyed."
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_perspective
    @perspective = @post.perspectives.find(params[:perspective_id])
  end

  def set_attachment
    @attachment = @perspective.attachments.find(params[:attachment_id])
  end

  def set_attachmentcounter
    @attachmentcounter = @attachment.attachmentcounters.find(params[:id])
  end

  def attachmentcounter_params
    params.require(:attachmentcounter).permit(:approved, :rejected)
  end
end
