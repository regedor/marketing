require "zip"

class PerspectivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_perspective, only: [ :show, :destroy, :update_status, :update_status_post, :update_copy ]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def show
    @attachment = @perspective.attachments.new
    @comment = @post.comments.new
    post_socialplatforms = @post.perspectives.map(&:socialplatform)
    post_perspectives = @post.perspectives
    new_perspectives = Socialplatform.all.reject { |socialplatform| post_socialplatforms.include?(socialplatform) }.map { |s| Perspective.new(socialplatform: s) }
    @perspectives = (post_perspectives + new_perspectives).sort_by { |perspective| perspective.socialplatform.present? ? perspective.socialplatform&.name : "Default" }
    @publishplatform = Publishplatform.where(post: @post).map { |pp| pp.socialplatform }
    @attachments = @post.perspectives.flat_map(&:attachments).select { |a| a.filename.present? && a.id.present? }.uniq { |a| a.filename }.sort_by { |a| a.created_at }
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives
  def create
    @perspective = @post.perspectives.new(perspective_params)
    @perspective.copy = @post.perspectives.reject { |p| p.socialplatform.present? }.map(&:copy).first

    if @perspective.save
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective was successfully created."
      send_notification("created", 0)

      LogEntry.create_log("Perspective has been created by #{current_user.email}. [#{perspective_params}]")
    else
      redirect_to calendar_post_path(@calendar, @post), alert: "Error creating Perspective."
      LogEntry.create_log("#{current_user.email} attempted to create perspective but failed (unprocessable_entity). [#{perspective_params}]")
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def destroy
    if @perspective.socialplatform.nil?
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "Perspective cannot be deleted."

      LogEntry.create_log("#{current_user.email} attempted to delete perspective #{@perspective.id} but failed.")
    else
      @perspective.destroy
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully destroyed."
      send_notification("destroyed", 2)

      LogEntry.create_log("Perspective #{@perspective.id} has been destroyed by #{current_user.email}.")
    end
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status
  def update_status
    @perspective.update(perspective_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective status updated."
    send_notification("changed status", 3)

    LogEntry.create_log("Perspective status has been updated by #{current_user.email}. [#{perspective_params_status}]")
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status_post
  def update_status_post
    @post.update(post_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Post status updated."
    send_notification_post("changed status", 3)

    LogEntry.create_log("Post status has been updated by #{current_user.email}. [#{post_params_status}]")
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_copy
  def update_copy
    @perspective.update(perspective_params_copy)
    send_notification("updated", 1)
    LogEntry.create_log("Perspective copy has been updated by #{current_user.email}. [#{perspective_params_copy}]")
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

    def send_notification(action, action_type)
      if @perspective.socialplatform.nil?
        Notification.create(description: "The perspective #{@perspective.id},the default perspective, has been #{action} by #{current_user.email}.  <#{calendar_post_url(@calendar, @post)}|Link>", type_notification: action_type, organization: current_user.organization, title: "Post #{@perspective.post.title}, Default perspective Notification")
      else
        Notification.create(description: "The perspective #{@perspective.id}, for the social media `#{@perspective.socialplatform.name}`, has been #{action} by #{current_user.email}. <#{calendar_post_perspective_url(@calendar, @post, @perspective)}|Link>", type_notification: action_type, organization: current_user.organization, title: "Post #{@perspective.post.title}, #{@perspective.socialplatform.name} perspective Notification")
      end
    end


    def send_notification_post(action, action_type)
      Notification.create(description: "The post #{@post.id}, with title `#{@post.title}`, has been #{action} by #{current_user.email}. <#{calendar_post_url(@calendar, @post)}|Link>.", type_notification: action_type, organization: current_user.organization, title: "Post #{@post.title} Notification")
    end
end
