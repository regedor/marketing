require "zip"

class PerspectivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_perspective, only: [ :show,  :edit, :update, :destroy, :download, :approved, :in_analysis, :rejected, :update_status, :update_status_post ]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def show
    @attachment = @perspective.attachments.new
    @comment = @post.comments.new
    all_socialplatforms = Socialplatform.all
    post_socialplatforms = @post.perspectives.map(&:socialplatform)
    @post_perspectives = @post.perspectives 
    @new_social_platforms = Socialplatform.all.reject{ |socialplatform| post_socialplatforms.include?(socialplatform) }
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/new
  def new
    @perspective_new = @post.perspectives.build
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives
  def create
    @perspective_new = @post.perspectives.new(perspective_params)
    @perspective_new.copy = "Default sei lá"

    if @perspective_new.save
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective_new), notice: "Perspective was successfully created."
    else
      puts "========================"
      puts @perspective_new.errors.full_messages.join(", ")
      @comment = @post.comments.new
      render :new, status: :unprocessable_entity
    end
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def update
    if @perspective.update(perspective_params)
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def destroy
    if @perspective.socialplatform.nil?
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "Perspective cannot be deleted."
    else
      @perspective.destroy
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully destroyed."
    end
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/approved
  def approved
    @perspective.update(status: "approved")
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective status updated to Approved."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/in_analysis
  def in_analysis
    @perspective.update(status: "in_analysis")
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective status updated to In Analysis."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/rejected
  def rejected
    @perspective.update(status: "rejected")
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective status updated to Rejected."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status
  def update_status
    @perspective.update(perspective_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective status updated."
  end

   # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status_post
  def update_status_post
    @post.update(post_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Post status updated."
  end

  def download
    attachments = @perspective.attachments.where(status: "approved").where.not(type_content: "cloud")
    zip_filename = "#{@perspective.id}_attachments.zip"
    zip_data = Zip::OutputStream.write_buffer do |zip|
      attachments.each do |attachment|
        zip.put_next_entry(attachment.filename)
        zip.print attachment.content
      end
    end
    zip_data.rewind
    send_data zip_data.read, filename: zip_filename, type: "application/zip", disposition: "attachment"
  end

  private
    def set_data
      @calendar = Calendar.find(params[:calendar_id])
      @post = Post.find(params[:post_id])
    end

    def set_perspective
      @perspective = @post.perspectives.find(params[:id])
    end

    def perspective_params
      params.require(:perspective).permit(:socialplatform_id)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def perspective_params_status
      params.require(:perspective).permit(:status)
    end

    def post_params_status
      params.require(:post).permit(:status)
    end
end
