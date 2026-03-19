Rails.application.routes.draw do
  get "plans/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Debugging endpoints
  get "/debug/health", to: "debug#health"
  get "/debug/auth", to: "debug#auth_debug"
  get "/debug/admin", to: "debug#admin_test"
  get "/debug/image", to: "debug#image_upload_debug"

  # Defines the root path route ("/")
  # root "posts#index"

  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"
  get "/verify-email", to: "auth#verify_email"
  get "/get-profile", to: "auth#get_user_profile"
  post "/resend-verification-email", to: "auth#resend_verification_email"
  get "/test_resend", to: "auth#test_resend"

  get "/auth/:provider/callback", to: "social_auth#callback"

  put "/profile", to: "profiles#update"
  get "/profile/download", to: "profiles#download"
  get "/cloudinary/signature", to: "cloudinary#signature"

  # Public API
  resources :categories, only: [ :index ]
  resources :products, only: [ :index, :show ]
  resources :plans, only: [ :index ]

  # Cart API
  get "/get-cart", to: "carts#index"
  post "/cart/add", to: "carts#add"
  post "/cart/update", to: "carts#update"

  # Orders API
  resources :orders, only: [ :index ] do
    post :checkout, on: :collection, to: "orders#create_checkout_session"
  end

  # Subscription API
  post "/subscribe", to: "subscriptions#create"
  post "/subscriptions/webhook", to: "subscriptions#webhook"

  # Admin API
  namespace :admin do
    get "dashboard", to: "dashboard#stats"
    resources :users, only: [ :index, :show, :update ]
    resources :orders, only: [ :index, :show, :update ]
  end

  resources :products, only: [ :index, :show, :create, :update, :destroy ]
  resources :categories, only: [ :index, :create, :update, :destroy ]
end
