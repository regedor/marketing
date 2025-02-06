class Dashboard::UsersController < BaseController
  before_action :authenticate_user!
  before_action :authorize_leader!
  before_action :set_user, only: [ :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :edit, :update, :destroy ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.organization = current_user.organization
    @user.password = Devise.friendly_token.first(8)

    if @user.update(user_params)
      @user.send_reset_password_instructions

      member = Member.create!(organization_id: current_organization.id, user_id: @user.id, isLeader: @user.isLeader,
        email: @user.email)
      @user.update(member_id: member)
      redirect_to dashboard_path, notice: "User was successfully created."
      LogEntry.create_log("User #{@user.email} has been created by #{current_user.email}. [#{user_params}]")
    else
      error_messages = @user.errors.full_messages.join(", ")
      redirect_to new_dashboard_user_path,  alert: "Failed to create user: #{error_messages}"
      LogEntry.create_log("#{current_user.email} attempted to create a user but failed (inprocessable_entity). [#{user_params}]")
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      @user.members.each { |m| m.update(email: @user.email, isLeader: @user.isLeader) }
      redirect_to dashboard_path, notice: "User was successfully updated."
      LogEntry.create_log("User #{@user.email} has been updated by #{current_user.email}. [#{user_params}\]")
    else
      error_messages = @user.errors.full_messages.join(", ")
      redirect_to edit_dashboard_user_path(@user),  alert: "Failed to create user: #{error_messages}"
      LogEntry.create_log("#{current_user.email} attempted to update a user but failed (inprocessable_entity).[#{user_params}]")
    end
  end

  def destroy
    @user.destroy!
    redirect_to dashboard_path, notice: "User was successfully deleted."

    LogEntry.create_log("User #{@user.email} has been deleted by #{current_user.email}.")
  end

  def organizations; end

  def change_organization
    organization_id = params[:organization_id]
    member = Member.find_by(user_id: current_user.id, organization_id: organization_id)

    if member
      current_user.update(organization_id: organization_id, member_id: member.id)
      redirect_to root_path, notice: "Organization has been changed."
      LogEntry.create_log("#{current_user.email} has changed organization to #{member.organization.name}.")
    else
      redirect_to root_path, alert: "Failed to change organization."
      LogEntry.create_log("#{current_user.email} attempted to change organization but failed.")
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :organization_id, :isLeader)
    end

    def authorize_leader!
     redirect_to root_path, alert: "Access Denied" unless current_user.isLeader
    end

    def set_user
      @user = User.find(params[:id])
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @user.organization_id
    end
end
