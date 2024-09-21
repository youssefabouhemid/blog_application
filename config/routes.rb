require "sidekiq/web"

Rails.application.routes.draw do
  get("posts/:post_id/comments", { to: "comments#list" })
  post("posts/:post_id/comments", { to: "comments#create" })
  patch("comments/:comment_id", { to: "comments#update" })
  delete("comments/:comment_id", { to: "comments#destroy" })

  # # sidekiq
  # mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  # posts controller
  get("posts", { to: "posts#list" })
  post("posts", { to: "posts#create" })
  patch("posts/:id", { to: "posts#update" })
  delete("posts/:id", { to: "posts#destroy" })




  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
   controllers: {
     sessions: "users/sessions",
     registrations: "users/registrations"
   }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
