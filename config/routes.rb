Rails.application.routes.draw do
  resources :users
  resources :viewings
  resources :reviews
  resources :casts
  resources :actors
  resources :movies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/movies_always_show', to: 'playlists#movies_always_show'
  get '/user_custom_movies', to: 'playlists#user_custom_movies'
  get '/establish_session', to: 'application#establish_session'
  post '/signup', to: 'application#signup'
  post '/login', to: 'application#login'
  post '/viewings', to: "viewings#create"
end
