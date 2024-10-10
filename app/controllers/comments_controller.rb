class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :set_post
  before_action :set_comment, only: [ :show, :edit, :update, :destroy ]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Comment was successfully created."
    else
      @comments = @post.comments # Load the comments in case of error
      render "posts/show" # Re-render the post show page with errors
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to calendar_post_path(@calendar, @post), notice: "Comment was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to calendar_post_path(@calendar, @post), notice: "Comment was successfully deleted."
  end

  private
    def set_calendar
      @calendar = Calendar.find(params[:calendar_id])
    end
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
