Rails.application.routes.draw do
  
  resources :logs,  only: [:index]

  post "/log",  to: "groovapi#log"

  root  to: "logs#index"
  
end