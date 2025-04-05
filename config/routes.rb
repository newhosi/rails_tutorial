# request URL /path will be mapped to the Path action in the Static Pages controller
Rails.application.routes.draw do
  # static
  root "homes#home" # "/" is the root path
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"

  # home
  get "/home", to: "homes#home"

  # users
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: [ :index, :new, :edit, :show, :update, :destroy ] do
    member do
      get :following
      get :followers
    end
  end

  # sessions
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # account activation
  resources :account_activations, only: [ :edit ]

  # password reset
  resources :password_resets, only: [ :new, :create, :edit, :update ]

  # microposts
  resources :microposts, only: [ :create, :destroy ] do
    # likes
    post "/likes", to: "post_likes#create"
    delete "/likes", to: "post_likes#destroy", as: "like"
  end

  # relationships
  resources :relationships, only: [ :create, :destroy ]

  match "*path", to: "application#not_found!", via: :all
end
