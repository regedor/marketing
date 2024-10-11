class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_attachment, only: [ :show, :edit, :update, :destroy, :download ]

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
      redirect_to [ @calendar, @post, @perspective ], notice: "Attachment was successfully created."
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
      redirect_to [ @calendar, @post, @perspective ], notice: "Attachment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id
  def destroy
    @attachment.destroy
    redirect_to [ @calendar, @post, @perspective ], notice: "Attachment was successfully destroyed."
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:perspective_id/attachments/:id/download
  def download
    send_data @attachment.content, filename: @attachment.filename, type: "application/octet-stream"
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
      params.require(:attachment).permit(:filename, :content, :status)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end
end
