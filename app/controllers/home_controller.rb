class HomeController < ApplicationController
  before_action :check_for_users, only: [ :index ]
  before_action :authenticate_user!, except: [ :first_setup ]

  def index
  end

  def first_setup
    Rails.logger.info "User count: #{User.count}"

    if User.count.zero?
      super_admin_email = ENV["SUPER_ADMIN_EMAIL"]

      @super_admin = User.find_or_initialize_by(email: super_admin_email)

      unless @super_admin.persisted?
        @super_admin.save(validate: false) # Save the user without validation
        @super_admin.send_reset_password_instructions

        flash[:notice] = "The instructions to set up the super admin were sent to #{super_admin_email}."
      end
    else
      redirect_to root_path
    end
  end

  private

  def check_for_users
    redirect_to first_setup_path if User.count.zero?
  end
end
