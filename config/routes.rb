Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  namespace :admin do
    #resources :users, only: [:index, :new, :create, :show, :edit, :update, :destroy]
    resources :users
  end
end
