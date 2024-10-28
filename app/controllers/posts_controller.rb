class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :check_organization!
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :update_design_idea, :download ]
  before_action :check_author!, only: [ :edit, :update, :destroy, :update_design_idea ]
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
  end

  # POST /calendars/:calendar_id/posts
  def create
    @post = @calendar.posts.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /calendars/:calendar_id/posts/:id/edit
  def edit
  end

  # PATCH /calendars/:calendar_id/posts/:id
  def update
    if @post.update(post_params)
      redirect_to calendar_post_path(@calendar, @post), notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:id
  def destroy
    @post.destroy
    redirect_to calendars_path(), notice: "Post was successfully deleted."
  end

  # PATCH /calendars/:calendar_id/posts/:id/update_design_idea
  def update_design_idea
    @post.update(perspective_params_design_idea)
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
      redirect_to root_path, alert: "Access Denied" unless current_user == @post.user
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
