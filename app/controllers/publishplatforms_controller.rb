class PublishplatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_publishplatform, only: [ :destroy ]
  before_action :check_author!, only: [ :create, :destroy ]

  def create
    begin
      @socialplatform = Socialplatform.find(params.require(:publishplatform).permit(:socialplatform_id)["socialplatform_id"])
      @publishplatform = Publishplatform.create!(
        post: @post,
        socialplatform: @socialplatform
      )
      render json: { message: "Publishplatform created successfully" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def destroy
    begin
      @publishplatform.destroy
      render json: { message: "Publishplatform deleted successfully" }, status: :ok
    rescue ActiveRecord::RecordNotDestroyed => e
      render json: { error: "Failed to delete Publishplatform: #{e.message}" }, status: :bad_request
    end
  end

  private
    def set_data
      @calendar = Calendar.find(params[:calendar_id])
      @post = Post.find(params[:post_id])
    end

    def check_organization!
      render json: { error: "You are not part of this organization"  }, status: :forbidden, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def check_author!
      return if current_user == @post.user || current_user.isLeader?

      render json: { error: "You are not the author" }, status: :forbidden, alert: "Access Denied"
    end

    def set_publishplatform
      @socialplatform = Socialplatform.find(params[:id])
      @publishplatform = Publishplatform.find_by(post: @post, socialplatform: @socialplatform)
    end
end
