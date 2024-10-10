Rails.application.routes.draw do
  resources :calendars do
    resources :posts do
      resources :perspectives do
        resources :attachments do
          resources :attachementcounters
        end
      end
      resources :comments
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  root "home#index"
  get "dashboard", to: "dashboard#index"

  namespace :dashboard do
    resources :users, only: [ :new, :create, :edit, :update, :destroy, :show ]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
