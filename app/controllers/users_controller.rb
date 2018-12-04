class UsersController < ApplicationController
  def index
    @user = User.all

    # @user_decks = Deck.where(user_id: @user.id)
  end

  def show
    @user_deck = User.find(params[:id])

  end

  def profile
    @user = User.find(params[:id])
    @user_decks = Deck.where(user_id: @user.id)
  end
end
