Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  get "/users" => "users#index"
  get "/profile/:id" => "users#profile", :as => :user_profile
  get "/users/:user_id/decks/:id/edit/:page_num" => "decks#edit"
  get "/users/:user_id/decks/:id/result/:search_name/:search_color/:search_type/:search_creature/:search_set/:page_num" => "decks#result"
  post "/search" => "decks#search"
  get "/users/:user_id/decks/:id/edit/:page_num" => "decks#edit"
  post "/destroy" => "decks#destroy"

  get "/decks" => "decks#index"

  post "/remove_card" => 'decks#removeCardFromDeck'


  post "/addcard" => "decks#addCardToDeck", :as => :add_card

  resources :users do
    resources :decks
  end

end
