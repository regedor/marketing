Rails.application.routes.draw do
  get "social", to: "social#index"
  get "crm/index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  root 'home#index'
  get 'first_setup', to: 'home#first_setup'

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy, :show]
  end

  resources :organizations

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
