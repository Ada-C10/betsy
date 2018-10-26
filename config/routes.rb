Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#root'

  resources :merchants, except: [:new, :create]
  resources :products do
    resources :reviews, only: [:new, :create]
  end

  resources :order_items, except: [:new]
  resources :orders, except: [:new]

  resources :sessions, only: [:new, :create]

  resources :categories, only: [:new, :create]

  get '/auth/:provider/callback', to: "sessions#create", as: 'auth_callback'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get '/merchants/:id/dashboard', to: 'merchants#dashboard', as: 'dashboard'

  post '/order_items/:id/status', to: 'order_items#status', as: 'order_items_status'

  get '/orders/:id/customerinfo', to: 'orders#customerinfo', as: 'customer_info'

end
