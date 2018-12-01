class UsersController < ApplicationController
  def index

  end

  def profile
    @user = current_user
    @user_decks = Deck.where(user_id: @user.id)
  end
end
