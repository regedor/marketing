class PerspectivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_perspective, only: [ :show, :edit, :update, :destroy, :approved, :in_analysis, :rejected ]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives
  def index
    @perspectives = @post.perspectives
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def show
    @attachment = @perspective.attachments.new
    @comment = @post.comments.new
    @perspective_new = @post.perspectives.new
  end

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/new
  def new
    @perspective_new = @post.perspectives.build
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives
  def create
    @perspective_new = @post.perspectives.new(perspective_params)

    if @perspective_new.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully created."
    else
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
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def destroy
    if @perspective.socialplatform.nil?
      redirect_to calendar_post_path(@calendar, @post), alert: "Perspective cannot be deleted."
    else
      @perspective.destroy
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully destroyed."
    end
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/approved
  def approved
    @perspective.update(status: "approved")
    redirect_to calendar_post_path(@calendar, @post), notice: "Perspective status updated to Approved."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/in_analysis
  def in_analysis
    @perspective.update(status: "in_analysis")
    redirect_to calendar_post_path(@calendar, @post), notice: "Perspective status updated to In Analysis."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/rejected
  def rejected
    @perspective.update(status: "rejected")
    redirect_to calendar_post_path(@calendar, @post), notice: "Perspective status updated to Rejected."
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
      params.require(:perspective).permit(:copy, :socialplatform_id)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end
end
