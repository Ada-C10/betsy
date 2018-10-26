Rails.application.routes.draw do
  root 'products#root'

  get "/auth/:provider/callback", to: "sessions#login", as: "auth_callback"
  delete "/logout", to: "sessions#destroy", as: "logout"
  get "users/:id/dashboard", to: "users#dashboard", as: "dashboard"
  get "users/:user_id/products", to: "users#products", as: "merchant_products"
  get "orders/:order_id/confirmation", to: "orders#confirmation", as: "confirmation"

  resources :users, only: [ :new, :create, :index]

  get '/sessions/current_order', to: "sessions#current_order", as: "current_order"

  resources :products, except: [:destroy] do
    post 'retire', to: "products#retire", as: "retire"
    post 'add_to_cart', to: "products#add_to_cart", as: "add_to_cart"
  end

  resources :categories, only: [ :new, :create, :index , :show]

  resources :orders, only: [:show, :update, :edit] do
    resources :orders_items, only: [:create, :new, :destroy,:update]
  end


end
