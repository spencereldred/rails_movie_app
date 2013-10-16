Movies::Application.routes.draw do
  root :to => 'movies#home'

  resources :movies

  match '/imdb/:id', to: 'movies#show'

  resources :reviews
  match '/reviews/new/:id', to: 'reviews#new'

end
