class PerspectivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :set_post
  before_action :set_perspective, only: [ :show, :edit, :update, :destroy ]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives
  def index
    @perspectives = @post.perspectives
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def show
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/new
  def new
    @perspective = @post.perspectives.build
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives
  def create
    @perspective = @post.perspectives.new(perspective_params)

    if @perspective.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully created."
    else
      @comment = @post.comments.new
      render "posts/show", status: :unprocessable_entity
    end
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def update
    if @perspective.update(perspective_params)
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def destroy
    @perspective.destroy
    redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully destroyed."
  end

  private
    def set_calendar
      @calendar = Calendar.find(params[:calendar_id])
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_perspective
      @perspective = @post.perspectives.find(params[:id])
    end

    def perspective_params
      params.require(:perspective).permit(:copy, :socialplatform_id)
    end
end
