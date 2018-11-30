class DecksController < ApplicationController
  def index
  end

  def new
    @cards = MTG::Card.where(name: 'umezawa').all
    @deck = Deck.new
    @user = current_user
  end

  def addCardToDeck
    card_id = params[:card_id]
    deck_id = params[:deck_id]

    @deck = Deck.find(2)

    @deck.cardlist += (card_id + ",")
    p @deck.cardlist
    @deck.save

    redirect_to "/"
  end

  def parseCardList

  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def decks_params
    params.require(:deck).permit(:name, :cardlist, :user_id)
  end
end
