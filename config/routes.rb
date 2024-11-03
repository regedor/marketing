Rails.application.routes.draw do
  resources :pipelines, only: [ :new, :show, :create, :edit, :update, :destroy, :index ] do
    collection do
      get :selector
      post :select_pipeline
    end
    resources :pipeattributes, only: [ :create, :edit, :update, :destroy ]
    resources :stages, only: [ :create, :edit, :update, :destroy ]
    resources :leads, only: [ :show, :new, :create, :edit, :update, :destroy, :index ] do
      member do
        patch :update_stage
      end
      resources :leadcontents
      resources :leadnotes, only: [ :create, :edit, :update, :destroy ]
    end
  end

  resources :companies, only: [ :show, :new, :create, :edit, :update, :destroy, :index ] do
    resources :companynotes, only: [ :create, :edit, :update, :destroy ]
    resources :companylinks do
      member do
        post :create_content
        delete :destroy_content
      end
    end
  end

  resources :people, only: [ :show, :new, :create, :edit, :update, :destroy, :index ] do
    resources :emails
    resources :phonenumbers
    resources :personnotes, only: [ :create, :edit, :update, :destroy ]
    resources :personlinks do
      member do
        post :create_content
        delete :destroy_content
      end
    end
  end

  resources :personcompanies do
    post "person/:person_id", to: "personcompanies#create_by_person", as: :create_by_person, on: :collection
    post "company/:company_id", to: "personcompanies#create_by_company", as: :create_by_company, on: :collection
    patch "person/:person_id/:company_id/is_working", to: "personcompanies#update_is_working_by_person", as: :update_is_working_by_person, on: :collection
    patch "company/:company_id/:person_id/is_working", to: "personcompanies#update_is_working_by_company", as: :update_is_working_by_company, on: :collection
    patch "person/:person_id/:company_id/is_my_contact", to: "personcompanies#update_is_my_contact_by_person", as: :update_is_my_contact_by_person, on: :collection
    patch "company/:company_id/:person_id/is_my_contact", to: "personcompanies#update_is_my_contact_by_company", as: :update_is_my_contact_by_company, on: :collection
    delete "person/:person_id/:company_id", to: "personcompanies#destroy_by_person", as: :destroy_by_person, on: :collection
    delete "company/:company_id/:person_id", to: "personcompanies#destroy_by_company", as: :destroy_by_company, on: :collection
  end

  resources :calendars, only: [ :index, :create, :edit, :update, :destroy ] do
    collection do
      get :selector
      post :select_calendar
    end
    resources :posts, only: [ :show, :new, :create, :edit, :update, :destroy ] do
      member do
        get :download
        patch :update_design_idea
      end

      resources :perspectives, only: [ :show, :create, :destroy ] do
        member do
          patch :update_status
          patch :update_status_post
          patch :update_copy
        end

        resources :attachments, only: [ :show, :create, :edit, :update, :destroy ] do
          member do
            get :download
            patch :like
            patch :dislike
            patch :update_status
          end
        end
      end

      resources :comments, only: [ :create, :edit, :update, :destroy ]
      resources :publishplatforms, only: [ :create, :destroy ]
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
    resources :users, only: [ :new, :create, :edit, :update, :destroy ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
