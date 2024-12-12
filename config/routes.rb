Rails.application.routes.draw do
  root to: "log_campaigns#index"

  devise_for :users, only: [ :session ]

  resources :diagnosis_logs
  resources :log_campaigns do
    collection do
      get :search
    end
    member do
      get :all
      get :log
      get :error
    end
  end

  resources :statuses, path: "status", only: [ :index ]

  resources :ignore_error_results

  get "about", to: "static_pages#about"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
