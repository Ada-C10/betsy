Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  get '/merchant/about_us', to: 'merchants#about_us', as: 'about_us'

  get '/product/:id/add_to_order', to: 'products#add_to_order', as: 'add_to_order'

  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'

  delete "/logout", to: "sessions#destroy", as: "logout"


  resources :orders do
    #put '/filter_status', to: 'orders#filter_status', as: 'filter_order'
  end

  resources :order_items, include: [:show, :delete]

  put '/update_order_item', to: 'order_items#update', as: 'order_items_update'

  put '/ship_me/', to: 'order_items#change_shipping_status', as:
  'ship_item'



  resources :categories do
    resources :products, include: [:index, :show, :create]
  end

  resources :merchants do
    resources :products, include: [:index, :show, :create]
    get '/order_summary', to: 'merchants#order_summary', as: 'order_summary'
  end


  resources :products, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    post '/add_order_item', to: 'order_items#create', as: 'order_items_create'
    resources :reviews, shallow: true
  end





  # NOTE: nested route ideas: merchants/id#/products and categories/id#/products ???

end
