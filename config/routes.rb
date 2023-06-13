Rails.application.routes.draw do
  resources :discounts
  resources :orders
  resources :items
  get 'discounts', action: :index, controller: 'discounts'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
