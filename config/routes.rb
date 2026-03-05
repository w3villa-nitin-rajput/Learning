Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"
  get "/verify-email", to: "auth#verify_email"
  get "/get-profile", to: "auth#get_user_profile"
  post "/resend-verification-email", to: "auth#resend_verification_email"

  get "/auth/:provider/callback", to: "social_auth#callback"

  put "/profile", to: "profiles#update"
  get "/cloudinary/signature", to: "cloudinary#signature"

  # Public API
  resources :categories, only: [:index]
  resources :products, only: [:index]

  # Cart API
  get "/get-cart", to: "carts#index"
  post "/cart/add", to: "carts#add"
  post "/cart/update", to: "carts#update"

  # Admin API
  namespace :admin do
    get "dashboard", to: "dashboard#stats"
    resources :users, only: [:index, :show, :update]
    resources :orders, only: [:index, :show, :update]
  end

  resources :products, only: [:index, :create, :update, :destroy]
  resources :categories, only: [:index, :create, :update, :destroy]
end
