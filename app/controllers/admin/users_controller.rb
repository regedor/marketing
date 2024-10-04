class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy] 
  
  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
    @organizations = Organization.all
  end

  def create
    @user = User.new(user_params)
    @user.password = Devise.friendly_token.first(8)
    if @user.save
      @user.send_reset_password_instructions
      redirect_to admin_dashboard_path, notice: 'User was successfully created.'
    else
      @organizations = Organization.all
      render :new
    end
  end

  def edit
    @organizations = Organization.all
  end

  def update
    if @user.update(user_params)
      redirect_to admin_dashboard_path, notice: 'User was successfully updated.'
    else
      @organizations = Organization.all
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy!
    redirect_to admin_dashboard_path, notice: 'User was successfully deleted.'
  end

  private

  def user_params
    params.require(:user).permit(:email, :organization_id)
  end

  def authorize_admin!
    redirect_to root_path, alert: 'Access Denied' unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end
end
