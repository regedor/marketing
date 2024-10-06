class Dashboard::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_leader!
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def show
    @user = User.find(params[:id])
    if @user.organization.present?
      @teams = Team.where(organization_id: @user.organization.id).where.not(id: @user.teams.pluck(:id))
    end
  end

  def new
    @user = User.new
    @organizations,@roles = get_organizations, get_roles
  end

  def create
    @user = User.new(user_params)
    @user.password = Devise.friendly_token.first(8)

    respond_to do |format|
      if have_access(@user) && correct_roles(@user.role) && @user.save
        @user.send_reset_password_instructions
        format.html { redirect_to dashboard_user_path(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        @user.errors.add(:base, "You must specifiy an organization that you have acess.") unless have_access(@user)
        @user.errors.add(:base, "The selected role is not correct.")  unless correct_roles(@user.role)
        @organizations,@roles = get_organizations, get_roles
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @organizations,@roles = get_organizations, get_roles
  end

  def update
    respond_to do |format|
      if have_access(@user) && correct_roles(@user.role) && @user.update(user_params)
        format.html { redirect_to dashboard_user_path(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :created, location: @user }
      else
        @user.errors.add(:base, "You must specifiy an organization that you have acess.") unless have_access(@user)
        @user.errors.add(:base, "The selected role is not correct.")  unless correct_roles(@user.role)
        @organizations,@roles = get_organizations, get_roles
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    if have_access(user) && !user.Admin?
      user.destroy!
      redirect_to dashboard_path, notice: "User was successfully deleted."
    else
      redirect_to root_path, alert: "Access Denied. You cannot delete this user"
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :organization_id, :role)
    end

    def authorize_leader!
      redirect_to root_path, alert: "Access Denied" unless current_user.Admin? || current_user.Leader?
    end

    def set_user
      @user = User.find(params[:id])
    end

    def get_organizations
      if current_user.Admin?
        Organization.all
      elsif current_user.organization.nil?
        []
      else
        [ Organization.find(current_user.organization.id) ]
      end
    end

    def have_access(user)
      current_user.Admin? || user.organization == current_user.organization
    end


    def get_roles
      if current_user.Admin?
        User.roles.keys.map { |role| [ role.humanize, role ] }
      else
        User.roles.keys.reject { |role| role == "Admin" }.map { |role| [ role.humanize, role ] }
      end
    end

    def correct_roles(role)
      current_user.Admin? || role != "Admin"
    end
end
