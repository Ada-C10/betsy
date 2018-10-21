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

  # Route for merchants to change status of their product
  patch '/merchants/:merchant_id/products/:id/status', to: 'products#status', as: 'products_status'

  # Route to order confirmation page
  get "/confirmation", to: 'orders#confirmation', as: "confirmation"

  # Route to order fulfillment page
  get "/fulfillment", to: 'merchants#fulfillment', as: "fulfillment"

  # Routes for OAuth
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"
  delete "/logout", to: "sessions#destroy", as: "logout"
end
