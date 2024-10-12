class AttachmentcountersController < ApplicationController 
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!

  def like
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.approved = true
    @attachmentcounter.rejected = false
    save_counter(@attachmentcounter)
  end

  def dislike
    @attachmentcounter = find_or_initialize_attachmentcounter
    @attachmentcounter.approved = false
    @attachmentcounter.rejected = true
    save_counter(@attachmentcounter)
  end

  private

    def set_data
      @calendar = Calendar.find(params[:calendar_id])
      @post = Post.find(params[:post_id])
      @perspective = @post.perspectives.find(params[:perspective_id])
      @attachment = @perspective.attachments.find(params[:attachment_id])    
    end

    def find_or_initialize_attachmentcounter
      Attachmentcounter.find_or_initialize_by(attachment_id: params[:attachment_id], user: current_user)
    end

    def attachmentcounter_params
      params.require(:attachmentcounter).permit(:approved, :rejected)
    end    

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def save_counter(attachmentcounter)
      if attachmentcounter.save
        redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Your response was successfully recorded."
      else
        redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "There was an error recording your response."
      end
    end
end
