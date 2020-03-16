Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  # 上記はこうも書ける。 match '/login', to: 'sessions#create', via: [:post, :patch, :put]
  delete '/logout', to: 'sessions#destroy'
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks do
    post :confirm, action: :confirm_new, on: :new #confirmというURLにPOSTリクエストを投げてください、 対応するactionは confirm_newです。 tasks/newに載せたURLにしてください
  end
end
