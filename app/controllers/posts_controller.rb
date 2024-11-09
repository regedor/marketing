require "date"
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :check_organization!
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :update_design_idea, :update_categories, :download, :update_day, :update_date_time ]
  before_action :check_author!, only: [ :edit, :update, :destroy ]
  before_action :sanitize_categories, only: [ :create, :update ]

  # GET /calendars/:calendar_id/posts/:id
  def show
    @perspective = Perspective.where(post: @post, socialplatform: nil).first
    if @perspective
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective)
    else
      redirect_to calendars_path()
    end
  end

  # GET /calendars/:calendar_id/posts/new
  def new
    @post = @calendar.posts.new
    @perspective = @post.perspectives.new

    if params[:date].present?
      new_date = Date.parse(params[:date])
      @post.publish_date = DateTime.new(new_date.year, new_date.month, new_date.day, 12, 0, 0)
    end
  end

  # POST /calendars/:calendar_id/posts
  def create
    @post = @calendar.posts.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Post was successfully created."

      LogEntry.create_log("Post has been created by #{current_user.email}. [#{post_params}]")
    else
      render :new, status: :unprocessable_entity

      LogEntry.create_log("#{current_user.email} attempted to create post but failed (unprocessable_entity). [#{post_params}]")
    end
  end

  # GET /calendars/:calendar_id/posts/:id/edit
  def edit
  end

  # PATCH /calendars/:calendar_id/posts/:id
  def update
    if @post.update(post_params)
      redirect_to calendar_post_path(@calendar, @post), notice: "Post was successfully updated."

      LogEntry.create_log("Post has been updated by #{current_user.email}. [#{post_params}]")
    else
      render :edit, status: :unprocessable_entity

      LogEntry.create_log("#{current_user.email} attempted to update post but failed (unprocessable_entity). [#{post_params}]")
    end
  end

  # DELETE /calendars/:calendar_id/posts/:id
  def destroy
    @post.destroy
    redirect_to calendars_path(), notice: "Post was successfully deleted."

    LogEntry.create_log("Post #{@post.title} has been destroyed by #{current_user.email}.")
  end

  # PATCH /calendars/:calendar_id/posts/:id/update_design_idea
  def update_design_idea
    @post.update(perspective_params_design_idea)
    LogEntry.create_log("Post design idea has been updated to In Analysis by #{current_user.email}. [#{perspective_params_design_idea}]")
  end

  def update_categories
    @post.update(categories: params[:post][:categories])
    head :ok
    LogEntry.create_log("Post categories have been updated by #{current_user.email}. [#{params[:post][:categories]}]")
  end

  # PATCH /calendars/:calendar_id/posts/:id/update_day
  def update_day
    begin
      new_date = Date.parse(params[:date])
      @post.publish_date = DateTime.new(new_date.year, new_date.month, new_date.day, @post.publish_date.hour, @post.publish_date.min, @post.publish_date.sec)
      if @post.save
        LogEntry.create_log("Publish date for post ID #{@post.id} has been updated to #{new_date} by #{current_user.email}.")

        render json: { success: true, new_publish_date: @post.publish_date.to_date, message: "Publish date updated to #{new_date}." }, status: :ok
      else
        render json: { success: false, error: "Failed to update publish date" }, status: :unprocessable_entity
      end
    rescue => e
      render json: { success: false, error: e.message }, status: :bad_request
    end
  end

  # posts_controller.rb
  def update_date_time
    begin
      new_datetime = DateTime.parse(params[:post][:date_time])
      if @post.update(publish_date: new_datetime)
        head :ok
      else
        render json: { error: "Failed to save" }, status: :unprocessable_entity
      end
    rescue ArgumentError
      render json: { error: "Invalid date format" }, status: :unprocessable_entity
    end
  end

  # GET /calendars/:calendar_id/posts/:id/download
  def download
    attachments = @post.perspectives.map { |p| p.attachments }.flatten.select { |a| a.status == "approved" }.reject { |a| a.type_content == "cloud" }
    zip_filename = "#{@post.id}_attachments.zip"
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
    def set_calendar
      @calendar = Calendar.find(params[:calendar_id])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(
        :title,
        :design_idea,
        :status,
        :publish_date,
        categories: [],
        perspectives_attributes: [
          :copy
        ]
      )
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def check_author!
      redirect_to root_path, alert: "Access Denied" unless current_user == @post.user || current_user.isLeader
    end

    def sanitize_categories
      if params[:post][:categories].present?
        params[:post][:categories] = params[:post][:categories].split(",").map(&:strip).reject(&:blank?)
      end
    end

    def perspective_params_design_idea
      params.require(:post).permit(:design_idea)
    end
end
