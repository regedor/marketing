require "zip"

class PerspectivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_perspective, only: [ :show, :destroy, :download, :update_status, :update_status_post, :update_copy ]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def show
    @attachment = @perspective.attachments.new
    @comment = @post.comments.new
    post_socialplatforms = @post.perspectives.map(&:socialplatform)
    post_perspectives = @post.perspectives
    new_perspectives = Socialplatform.all.reject { |socialplatform| post_socialplatforms.include?(socialplatform) }.map { |s| Perspective.new(socialplatform: s) }
    @perspectives = (post_perspectives + new_perspectives).sort_by { |perspective| perspective.socialplatform.present? ? perspective.socialplatform&.name : "Default" }
    @publishplatform = Publishplatform.where(post: @post).map { |pp| pp.socialplatform }
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives
  def create
    @perspective_new = @post.perspectives.new(perspective_params)
    @perspective_new.copy = @post.perspectives.reject { |p| p.socialplatform.present? }.map(&:copy).first

    if @perspective_new.save
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective_new), notice: "Perspective was successfully created."

      LogEntry.create_log("Perspective has been created by #{current_user.email}. [#{perspective_params}]")
    else
      @comment = @post.comments.new
      redirect_to calendar_post_perspective_path(@calendar, @post), alert: "Error creating Perspective."
      LogEntry.create_log("#{current_user.email} attempted to create perspective but failed (unprocessable_entity). [#{perspective_params}]")
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def destroy
    if @perspective.socialplatform.nil?
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "Perspective cannot be deleted."

      LogEntry.create_log("#{current_user.email} attempted to delete perspective but failed. [#{perspective_params}]")
    else
      @perspective.destroy
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully destroyed."

      LogEntry.create_log("Perspective has been destroyed by #{current_user.email}. [#{perspective_params}]")
    end
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status
  def update_status
    @perspective.update(perspective_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective status updated."

    LogEntry.create_log("Perspective status has been updated by #{current_user.email}. [#{perspective_params}]")
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status_post
  def update_status_post
    @post.update(post_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Post status updated."

    LogEntry.create_log("Post status has been updated by #{current_user.email}. [#{post_params_status}]")
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_copy
  def update_copy
    @perspective.update(perspective_params_copy)
    LogEntry.create_log("Perspective copy has been updated by #{current_user.email}. [#{perspective_params_copy}]")
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
      params.require(:perspective).permit(:socialplatform_id, :copy)
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

    def perspective_params_copy
      params.require(:perspective).permit(:copy)
    end
end
