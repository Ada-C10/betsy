Rails.application.routes.draw do
  get 'products/index'
  get 'products/show'
  get 'products/update'
  get 'products/new'
  get 'products/create'
  get 'products/edit'
  get 'products/destroy'
  get 'categories/new'
  get 'categories/create'
  get 'orders/new'
  get 'orders/create'
  get 'orders/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
