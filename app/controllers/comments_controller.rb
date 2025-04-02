class CommentsController < BaseController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :check_author!, only: [ :edit, :update ]
  before_action :check_leader!, only: [ :destroy ]

  # POST /calendars/:calendar_id/posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      title = "> New comment on post `#{@post.publish_date.strftime("%Y-%m-%d, %H:%M")}`"
      notification_message = "#{@comment.user.email}, (#{@comment.updated_at.strftime('%Y-%m-%d | %H:%M')}): #{@comment.content}"

      # @todo: when multitenancy is implemented, this should be scoped to the current organization
      Notification.create!(title: title, description: notification_message,  organization: @post.calendar.organization)

      redirect_to calendar_post_path(@calendar, @post, anchor: dom_id(@comment)), notice: "Comment was successfully created."

      LogEntry.create_log("Comment has been created by #{current_user.email} (#{}). [#{comment_params}]")
    else
      error_messages = @comment.errors.full_messages.join(", ")
      redirect_to calendar_post_path(@calendar, @post, anchor: "comments_info"), alert: "Failed to create comment: #{error_messages}"

      LogEntry.create_log("#{current_user.email} attempted to create comment but failed (error: #{error_messages}). [#{comment_params}]")
    end
  end

  # GET /calendars/:calendar_id/posts/:post_id/comments/:id/edit
  def edit
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/comments/:id
  def update
    if @comment.update(comment_params)
      redirect_to calendar_post_path(@calendar, @post, anchor: dom_id(@comment)), notice: "Comment was successfully updated."

      LogEntry.create_log("Comment has been updated by #{current_user.email}. [#{comment_params}]")
    else
      render :edit, status: :unprocessable_entity

      LogEntry.create_log("#{current_user.email} attempted to update comment but failed (unprocessable_entity). [#{comment_params}]")
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/comments/:id
  def destroy
    @comment.destroy
    redirect_to calendar_post_path(@calendar, @post, anchor: "comments_info"),  notice: "Comment was successfully deleted."

    LogEntry.create_log("Comment #{@comment.id} has been destroyed by #{current_user.email}.")
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
      return if current_organization.slug == "medgical" && @post.user.organization.slug == "regedor-creations"

      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def check_author!
      return if current_organization.slug == "medgical" && @post.user.organization.slug == "regedor-creations"

      redirect_to root_path, alert: "Access Denied" unless current_user == @comment.user
    end

    def check_leader!
      check_author! unless current_user.isLeader
    end
end
