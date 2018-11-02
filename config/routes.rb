Rails.application.routes.draw do
  root "home#index"
  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :users, except: [:new]
  resources :products, except: [:destroy]
  resources :categories, only: [:new, :create]

  get "/merchant/:id", to: "users#merchant_dash", as: "merchant_dash"
  patch "/merchant/:id", to: "users#update", as: "merchant"

  resources :order_products, only: [:create, :update, :destroy]
  patch "order_product/:id/:status", to: "order_products#change_status", as: "change_status"

  resources :orders, only: [:index, :update]
  get "/cart", to: "orders#cart", as: "cart"
  get "/checkout", to: "orders#checkout", as: "checkout"
  get "/confirmation", to: "orders#confirmation", as: "confirmation"

  patch "/products/:id/retire", to: "products#retire", as: "retire"
  get "/products/category/:id", to: "products#bycategory", as:"bycategory"
  get "/products/merchant/:id", to: "products#bymerchant", as:"bymerchant"

  resources :reviews, only: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
