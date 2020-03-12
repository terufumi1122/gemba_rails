Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :new, :edit, :show]
  end
  root to: 'tasks#index'
  resources :tasks
end
