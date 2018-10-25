Rails.application.routes.draw do


  root 'products#homepage'

  resources :order_items
  put '/orders/confirmation', to: 'orders#confirmation', as: 'confirmation'
  get 'orders/nosnacks', to: 'orders#nosnacks', as: 'nosnacks'
  get 'orders/:id/finalize', to: 'orders#finalize', as: 'finalize'
  get 'orders/summary/:id', to: 'orders#summary', as: 'summary'
  post 'products/:id/order_items', to: 'order_items#create', as: 'add_item'
  post 'order_items/:id/ship', to: 'order_items#ship', as: 'ship'

  # get 'pages/search', to: 'pages'
  resources :orders
  resources :categories

  resources :products do
    resources :order_items, only: [:index, :show, :create, :update]
  end

  resources :merchants
  resources :sessions

  get '/home', to: 'products#homepage', as: 'home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/myaccount/orders', to: 'merchants#account_order', as: 'merchant_order'

  get '/myaccount', to: 'merchants#account', as: 'merchant_account'

  get "/auth/:provider/callback", to: "merchants#create", as: 'merchant_callback'

  delete "/logout", to: "merchants#destroy", as: "logout"
  post "/products/:id", to: "merchants#status_change", as: 'status_change'

  post '/products/:id/reviews', to: 'reviews#create', as: 'create_review'

end
