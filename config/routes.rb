Rails.application.routes.draw do
  resources :calendars, only: [ :index, :create, :edit, :update, :destroy ] do
    collection do
      get :selector
      post :select_calendar
    end
    resources :posts, only: [ :show, :new, :create, :edit, :update, :destroy ] do
      member do
        patch :approved
        patch :in_analysis
        patch :rejected
      end

      resources :perspectives, only: [ :show, :new, :create, :edit, :update, :destroy ] do
        member do
          get :download
          patch :approved
          patch :in_analysis
          patch :rejected
        end

        resources :attachments, only: [ :create, :edit, :update, :destroy ] do
          member do
            get :download
            patch :approved
            patch :in_analysis
            patch :rejected
            patch :like
            patch :dislike
            patch :update_status
          end
        end
      end

      resources :comments, only: [ :create, :edit, :update, :destroy ]
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
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
