Rails.application.routes.draw do
  root 'products#root'

  resources :merchants do
    resources :products, only: [:index, :show, :new, :create]
  end

  resources :reviews, except: [:index, :show]
  resources :orders
  resources :products, except: [:new, :create]
  resources :categories, only: [:index, :show, :new, :create]

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"
end
