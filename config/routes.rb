Rails.application.routes.draw do

  # Set up ActionCable for live updates.
  mount ActionCable.server => '/cable'
  
  # Set up views for logs.
  resources :logs,  only: [:index] do
    get "live", on: :collection
  end

  # Set up API endpoints for Groov controllers.
  post "/log",  to: "groovapi#log"

  # Set shortcut URLs.
  root  to: "logs#index"
  get   "/live",  to: "logs#live"
  get   "/live/:with_controller",  to: "logs#live"
  
end