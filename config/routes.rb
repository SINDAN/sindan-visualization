Rails.application.routes.draw do
  root to: 'diagnosis_logs#index'

  resources :diagnosis_logs
  resources :log_units
end
