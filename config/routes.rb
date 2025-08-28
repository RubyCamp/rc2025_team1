Rails.application.routes.draw do
    get "inquiry", to: "inquiry#inquiry"
  post "inquiry", to: "inquiry#inquiry"
  get "sessions/new"
  post "sessions/create", as: "singup"
  get "sessions/destroy"
  get "sessions/profile"
  get "sessions/login"
  post "sessions/check"
  resources :onsens, only: %i[ index show ] do
    resources :reviews, only: %i[ create new ]
  end

  namespace :admin do
    root "onsens#index"
    resources :onsens
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "onsens#index"
end
