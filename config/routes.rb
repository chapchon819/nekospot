require 'sidekiq/web'

Rails.application.routes.draw do
  Sidekiq::Web.use(Rack::Auth::Basic) do |user_id, password|
    [user_id, password] == [ENV['SIDEKIQ_BASIC_ID'], ENV['SIDEKIQ_BASIC_PASSWORD']]
  end
  mount Sidekiq::Web, at: '/sidekiq'
  get 'rewiews/new'
  get 'rewiews/create'
  get 'users/show'
  root "static_pages#index"
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users/auth/failure' => 'omniauth_callbacks#failure'
  end
  post 'presigned_post', to: 'reviews#presigned_post'
  get 'spot_images/:photo_reference', to: 'spot_images#show', as: 'spot_image_proxy'
  get 'static_pages/index'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_use', to: 'static_pages#terms_of_use'
  get 'spots/list', to: 'spots#list'
  get 'reviews/search', to: 'reviews#search'
  get 'proxy_image', to: 'spots#proxy_image'
  get '/sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/#{ENV['BUCKET_NAME']}/sitemaps/sitemap.xml.gz")
  resources :spots, only: %i[index show] do
    get 'tag_filter/:tag_id', to: 'spots#index', as: :tag_filter_reviews
    resources :reviews, only: %i[new create show edit update destroy]
    collection do
      get :bookmarks
      get :map
      get :search
      get :visits
    end
  end
  resources :screenshots, only: [:create] do
    collection do
      post :update_meta_tags
    end
  end
  resources :spot_bookmarks, only: %i[create destroy]
  resources :helpfuls, only: %i[create destroy]
  resources :visits, only: %i[create destroy]
  resources :tags, only: %i[] do
    collection do
      get :search
    end
  end
  resources :diagnostics, only: [] do
    member do
      get 'question', to: 'diagnostics#show_question', as: 'question'
      post 'answer_question', to: 'diagnostics#answer_question'
    end
    collection do
      get 'start', to: 'diagnostics#start'
      get 'result', to: 'diagnostics#result'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
