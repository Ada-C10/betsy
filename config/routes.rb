Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root 'products#index', as: 'root'

  root 'products#root', as:'root'

  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'

  resources :order_items, only: [:create, :update, :destroy]

  patch '/order_item/:id/update_status', to: 'order_items#update_order_item_status', as: 'update_order_item_status'

  resources :orders, only: [:show, :create, :update, :destroy]

  get '/checkout', to: 'orders#edit', as: 'checkout'

  get '/cart', to: 'orders#index', as: 'cart'

  resources :products, except: [:new, :create, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create, :index]
  end

  resources :categories, except: [:destroy] do
    resources :products, only: [:index]
  end

  resources :merchants, only: [:index] do
    resources :products, except: [:show, :destroy] do
      member do
        post :change_status
      end
    end
  end

  get '/dashboard', to: 'merchants#show', as: 'dashboard'

  resources :sessions, only: [:new, :create]
  post '/sessions/logout', to: 'sessions#logout', as: 'logout'
end
