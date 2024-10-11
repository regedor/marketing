class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :check_organization!
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :check_author!, only: [ :edit, :update, :destroy ]

  # GET /posts
  def index
    @calendars = Calendar.where(organization: current_user.organization)
    @posts = Post.where(calendar_id: @calendars.pluck(:id)) unless @calendars.empty?
  end

  # GET /posts/:id
  def show
    @comment = @post.comments.new
    @perspective = @post.perspectives.new
  end

  # GET /posts/new
  def new
    @post = @calendar.posts.new
    @perspective = @post.perspectives.new
  end

  # POST /posts
  def create
    @post = @calendar.posts.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id/edit
  def edit
  end

  # PATCH/PUT /posts/:id
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully destroyed."
  end

  private

    # Set the calendar based on the calendar_id parameter
    def set_calendar
      @calendar = Calendar.find(params[:calendar_id])
    end

    # Find the post for actions like show, edit, update, and destroy
    def set_post
      @post = Post.find(params[:id])
    end

    # Strong parameters: Only allow the trusted parameters for post
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
