class Users::SessionsController < Devise::SessionsController
  respond_to :json, :html
end
