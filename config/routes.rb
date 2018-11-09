Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#index'
  get "/status/findform", to: 'status#findform'
  get "/status/:id", to: 'status#show', as: 'status'
  post "/status/detail", to: 'status#detail', as: 'detail'

  get "users/pending", to: 'users#merchant_pending_orders', as: 'pending'
  post "/users/:item_id/paid", to: 'users#paid', as: 'paid'

  # resources :status
  resources :users, only: [:show, :shop, :orders]
  resources :orders, :items, :reviews, :category

  resources :order_items, only: [:update, :destroy]


  resources :items do
    post '/order_items', to: 'order_items#create'
    patch 'order_items', to: 'order_items#increment_quantity', as: 'increment_quantity'

    resources :reviews
  end

get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'
post '/logout', to: 'sessions#logout', as: 'logout'

get '/shop', to: 'users#shop', as: 'shop'
end
