class Dashboard::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_leader!
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.organization = current_user.organization
    @user.password = Devise.friendly_token.first(8)

    respond_to do |format|
      if  @user.save
        @user.send_reset_password_instructions
        format.html { redirect_to dashboard_user_path(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @organizations = get_organizations
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to dashboard_user_path(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to dashboard_path, notice: "User was successfully deleted."
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

    def get_organizations
      if current_user.organization.nil?
        []
      else
        [ Organization.find(current_user.organization.id) ]
      end
    end

    def have_access(user)
      user.organization == current_user.organization
    end
end
