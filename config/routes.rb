Rails.application.routes.draw do


  root 'products#homepage'

  resources :order_items
  put '/orders/confirmation', to: 'orders#confirmation', as: 'confirmation'
  get 'orders/:id/finalize', to: 'orders#finalize', as: 'finalize'
  resources :orders
  resources :categories

  resources :products do
    resources :order_items, only: [:index, :show, :create, :update]
  end

  resources :merchants
  resources :sessions

  get '/home', to: 'products#homepage', as: 'home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/merchants/:id/myaccount', to: 'merchants#account', as: 'merchant_account'


  get "/auth/:provider/callback", to: "merchants#create", as: 'merchant_callback'
  delete "/logout", to: "merchants#destroy", as: "logout"
  post "/products/:id", to: "merchants#status_change", as: 'status_change'

<<<<<<< HEAD
=======
  post '/products/:id/reviews', to: 'reviews#create', as: 'create_review'

  # resources :reviews
>>>>>>> image-de
end
