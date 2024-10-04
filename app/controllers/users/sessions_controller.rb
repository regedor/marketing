class Users::SessionsController < Devise::SessionsController
    respond_to :json, :html

    def create
        super do |user|
            if request.format.json?
                token = JsonWebToken.encode(user_id: resource.id)
                render json: { token: token.first }, status: :ok
            end
        end
    end
end
  