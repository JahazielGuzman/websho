Rails.application.routes.draw do
  resources :users
  resources :viewings
  resources :reviews
  resources :casts
  resources :actors
  resources :movies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
