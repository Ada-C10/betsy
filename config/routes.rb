Rails.application.routes.draw do
  root 'pages#home'

  resources :merchants do
    resources :products
  end

  resources :reviews, except: [:index, :show]
  resources :orders
  resources :products, only: [:index, :show, :update, :create]
  resources :categories, only: [:index, :show, :new, :create]
  resources :orderitems, only: [:create, :update, :destroy]

  # get "/layouts/"
  # Think about how to create empty cart layout

  get "/empty_cart", to: 'orders#show', as: "empty_cart"
  patch '/merchants/:merchant_id/products/:id/status', to: 'products#status', as: 'products_status'
  get "/account", to: "merchants#account", as: 'account'
  get "/confirmation", to: 'orders#confirmation', as: "confirmation"
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"
  delete "/logout", to: "sessions#destroy", as: "logout"
end
