Rails.application.routes.draw do
  root to: 'log_campaigns#index'

  devise_for :users, only: [ :session ]

  resources :diagnosis_logs
  resources :log_campaigns do
    member do
      get :all
      get :log
      get :error
    end
  end

  get 'about', to: 'static_pages#about'
end
