Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  get "/users" => "users#index"
  get "/profile/:id" => "users#profile", :as => :user_profile
  post "/search" => "decks#search"
  get "/users/:user_id/decks/:id/edit/:page_num" => "decks#edit"

  post "/addcard" => "decks#addCardToDeck", :as => :add_card

  resources :users do
    resources :decks
  end

end
