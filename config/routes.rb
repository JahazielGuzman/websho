Rails.application.routes.draw do
  resources :users
  resources :viewings
  resources :reviews
  resources :casts
  resources :actors
  resources :movies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/newest_releases', to: 'playlists#newest_releases'
  post '/signup', to: 'application#signup'
  post '/login', to: 'application#login'
end
