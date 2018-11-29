class DecksController < ApplicationController
  $set = MTG::Set.all
  def index
    @user = current_user
    @decks = Deck.where(user_id: @user.id)
  end

  def new
    @deck = Deck.new
  end

  def create
    @user = current_user
    deck = Deck.new(deck_params)
    if deck.save
      redirect_to "/"
    else 
      redirect_to "/users/#{@user.id}/decks/new"
    end
  end

  def search
    if(params[:name] != nil)
      @card = MTG::Card.where(name: params[:name])
    end
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
  def deck_params
    params.require(:deck).permit(:name, :cardlist, :user_id)
  end


end
