Rails.application.routes.draw do
  resources :teams_users
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  root "home#index"
  get "first_setup", to: "home#first_setup"
  get "dashboard", to: "dashboard#index"

  namespace :dashboard do
    resources :users, only: [ :new, :create, :edit, :update, :destroy, :show ] do
      resources :teams_users, only: [ :create ]
    end
    resources :organizations, except: [ :index ] do
      resources :teams
    end
  end



  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
