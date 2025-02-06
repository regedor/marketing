class BaseController < ApplicationController
  before_action :set_current_user
  before_action :set_current_member
  before_action :set_current_organization

  private

  def set_current_user
    @current_user = @current_user
  end

  def set_current_member
    return unless @current_user
    @current_member = @current_user&.members.find_by(organization_id: @current_user.organization_id)
  end

  def set_current_organization
    @current_organization = @current_user&.organization
  end
end
