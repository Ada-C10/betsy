Rails.application.routes.draw do
  root 'pages#home'

  resources :merchants, only: [:index, :show] do
    resources :products, except: [:destroy]
  end

  resources :reviews, only: [:create]
  resources :orders, only: [:show, :edit, :update]
  resources :products, only: [:index, :show, :update, :create]
  resources :categories, only: [:index, :show]
  resources :orderitems, only: [:create, :update, :destroy]

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
