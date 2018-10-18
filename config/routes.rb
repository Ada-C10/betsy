Rails.application.routes.draw do
  root 'products#root'

  resources :merchants do
    resources :products, only: [:index, :show, :new]
  end

  resources :reviews, except: [:index, :show]
  resources :orders
  resources :products

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"
end

# do we want a join table between merchants and orders, or a nested route with index (order fulfillment) and show (individual order) via merchant 
