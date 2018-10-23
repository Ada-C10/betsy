Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#root'

  resources :merchants
  resources :products do
    resources :reviews, only: [:new, :create]
  end

  resources :order_items, except: [:new]
  resources :orders

  resources :sessions, only: [:new, :create]

  get '/auth/:provider/callback', to: "sessions#create", as: 'auth_callback'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

end
