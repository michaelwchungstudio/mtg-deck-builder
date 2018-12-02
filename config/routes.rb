Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  get "/users" => "users#index"
  get "/profile/:id" => "users#profile", :as => :user_profile
  get "/users/:user_id/decks/:id/edit/:page_name" => "decks#edit"
  get "/users/:user_id/decks/:id/result" => "decks#result"
  post "/search" => "decks#search"

  resources :users do
    resources :decks
  end

end
