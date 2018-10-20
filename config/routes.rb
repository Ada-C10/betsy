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

  get "layouts/empty_cart", to: 'pages#empty_cart', as: 'empty_cart'

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"
end
