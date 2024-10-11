class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :set_post
  before_action :set_perspective
  before_action :set_attachment, only: [:show, :edit, :update, :destroy, :download]

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
    @attachment = @perspective.attachments.build(attachment_params)

    if @attachment.save
      redirect_to [@calendar, @post, @perspective], notice: "Attachment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def update
    if @attachment.update(attachment_params)
      redirect_to [@calendar, @post, @perspective], notice: "Attachment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def destroy
    @attachment.destroy
    redirect_to [@calendar, @post, @perspective], notice: "Attachment was successfully destroyed."
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/download
  def download
    send_data @attachment.content, filename: @attachment.filename, type: "application/octet-stream"
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
    @attachment = @perspective.attachments.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:filename, :content, :status)
  end
end
