class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_comment, only: [ :show, :edit, :update, :destroy ]
  before_action :check_author!, only: [ :edit, :update, :destroy ]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Comment was successfully created."
    else
      @perspective = @post.perspectives.new
      error_messages = @comment.errors.full_messages.join(", ")
      redirect_to calendar_post_path(@calendar, @post), alert: "Failed to create comment: #{error_messages}"
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to calendar_post_path(@calendar, @post), notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to calendar_post_path(@calendar, @post), notice: "Comment was successfully deleted."
  end

  private
    def set_data
      @calendar = Calendar.find(params[:calendar_id])
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def check_author!
      redirect_to root_path, alert: "Access Denied" unless current_user == @comment.user
    end
end
