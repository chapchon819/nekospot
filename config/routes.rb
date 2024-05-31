Rails.application.routes.draw do
  get 'rewiews/new'
  get 'rewiews/create'
  get 'users/show'
  root "static_pages#index"
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    registrations: 'users/registrations'
  }
  get 'static_pages/index'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_use', to: 'static_pages#terms_of_use'
  get 'spots/list', to: 'spots#list'
  get 'reviews/search', to: 'reviews#search'
  resources :spots, only: %i[index show] do
    resources :reviews, only: %i[new create edit update destroy]
    collection do
      get :bookmarks
      get :map
      get :search
    end
  end
  resources :spot_bookmarks, only: %i[create destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
