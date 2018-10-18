Rails.application.routes.draw do

  root 'products#homepage'

  resources :order_items
  resources :orders
  resources :categories

  resources :products do
    resources :order_items, only: [:index, :show, :create, :update]
  end

  resources :merchants
  resources :sessions

  get '/home', to: 'products#homepage', as: 'home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
