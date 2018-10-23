Rails.application.routes.draw do
  root 'pages#home'

  resources :merchants do
    resources :products
  end

  resources :reviews, except: [:index, :show]
  resources :orders, except: [:index, :new, :destroy, :create]
  resources :products, only: [:index, :show, :update, :create]
  resources :categories, only: [:index, :show, :new, :create]
  resources :orderitems, only: [:create, :update, :destroy]


  # Route for merchant to view customer information and print shipping label
  get '/merchants/:merchant_id/:order_id', to: 'merchants#customer', as: 'merchant_customer'

  # Route for merchant to change status of their order (ship it)
  patch '/merchants/ship', to: 'merchants#ship', as: 'merchant_ship'

  # Route for merchants to change status of their product
  patch '/merchants/:merchant_id/products/:id/status', to: 'products#status', as: 'products_status'

  # Route to order dashboard page
  get "/dashboard", to: 'merchants#dashboard', as: "dashboard"

  # Route for search
  get '/search', to: 'search#search', as: "search"

  # Routes for OAuth
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"
  delete "/logout", to: "sessions#destroy", as: "logout"
end
