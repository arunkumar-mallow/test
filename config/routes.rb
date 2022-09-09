Rails.application.routes.draw do
  resources :posts
  root "posts#index"

  post "/posts/ratings", to: "posts#ratings"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
