class PublishplatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_organization!
  before_action :set_data
  before_action :check_author!, only: [:create, :destroy]

  def create
    socialplatform_ids = publishplatform_params[:socialplatform_ids] || []

    socialplatform_ids.each do |socialplatform_id|
      @publishplatform_new = @post.publishplatforms.new(socialplatform_id: socialplatform_id)
      @publishplatform_new.copy = @post.publishplatforms.reject { |p| p.socialplatform.present? }.map(&:copy).first
      
      unless @publishplatform_new.save
        render :new, alert: "Error creating publish platform." and return
      end
    end

    redirect_to calendar_post_path(@calendar, @post), notice: "Publish platforms created successfully."
  end

  def destroy
    @publishplatform.destroy
    redirect_to calendar_post_path(@calendar, @post), notice: "Publish platform deleted successfully."
  end

  private

  def set_data
    @calendar = Calendar.find(params[:calendar_id])
    @post = Post.find(params[:post_id])
  end

  def publishplatform_params
    params.require(:publishplatform).permit(:socialplatform_id)
  end

  def check_organization!
    redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
  end

  def check_author!
    redirect_to root_path, alert: "Access Denied" unless current_user == @post.user
  end
end
