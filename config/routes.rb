Rails.application.routes.draw do
  get "/auth/:provider/callback", to: "users#create"
  # delete "/logout", to: "sessions#destroy", as: "logout"

  resources :users
  resources :orders, except: [:destroy]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
