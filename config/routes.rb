Rails.application.routes.draw do
  root "articles#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/register", to: "users#new"
  post "/users", to: "users#create"

  resources :articles do
    member do
      post :report
    end
  end
end
Rails.application.routes.draw do
  root "articles#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/register", to: "users#new"
  post "/users", to: "users#create"

  resources :articles do
    member do
      post :report
    end
  end
end
