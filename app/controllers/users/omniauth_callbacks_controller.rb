class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.find_or_initialize_by(from_google_params)
    if user.id.present?
      sign_out_all_scopes
      sign_in user, event: :authentication
      flash[:notice] = t("devise.omniauth_callbacks.success", kind: "Google")
      redirect_to root_path, event: :authentication
    else
      flash[:alert] = t("devise.omniauth_callbacks.failure", kind: "Google", reason: "#{auth.info.email} is not authorized.")
      redirect_to new_user_session_path
    end
  end

  private
    def from_google_params
      @from_google_params ||= {
        email: auth.info.email
      }
    end

    def auth
      @auth ||= request.env["omniauth.auth"]
    end
end
