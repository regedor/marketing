class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :check_organization!
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :approved, :in_analysis, :rejected ]
  before_action :check_author!, only: [ :edit, :update, :destroy ]

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

  # PATCH /calendars/:calendar_id/posts/:id/approved
  def approved
    @post.update(status: "approved")
    redirect_to calendar_post_path(@calendar, @post), notice: "Post status updated to Approved."
  end

  # PATCH /calendars/:calendar_id/posts/:id/in_analysis
  def in_analysis
    @post.update(status: "in_analysis")
    redirect_to calendar_post_path(@calendar, @post), notice: "Post status updated to In Analysis."
  end

  # PATCH /calendars/:calendar_id/posts/:id/rejected
  def rejected
    @post.update(status: "rejected")
    redirect_to calendar_post_path(@calendar, @post), notice: "Post status updated to Rejected."
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
end
