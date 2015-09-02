Rails.application.routes.draw do
  root to: 'diagnosis_logs#index'

  resources :diagnosis_logs
  resources :log_campaigns do
    member do
      get :all
      get :log
      get :error
    end
  end
end
