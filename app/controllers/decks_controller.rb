class DecksController < ApplicationController

  $set = MTG::Set.all
  
  def index
    @user = current_user
    @decks = Deck.where(user_id: @user.id)
  end

  def new
    @deck = Deck.new
  end

  def addCardToDeck
    @user = current_user
    card_id = params[:card_id]
    deck_id = params[:deck_id]

    @deck = Deck.find(deck_id)

    @deck.cardlist += (card_id + ",")

    @deck.save

    redirect_to "/users/#{@user.id}/decks/#{@deck.id}/edit/1"
  end

  def create
    @user = current_user
    deck = Deck.new(deck_params)
    if deck.save
      redirect_to "/users/#{@user.id}/decks/#{deck.id}/edit/1"
    else
      redirect_to "/users/#{@user.id}/decks/new"
    end
  end

  def show
  end

  def edit
    @deck = Deck.where(id: params[:id]).first
    @user = current_user

    @deck_card_names = []
    @deck_card_images = []

    deck_card_list_array = @deck.cardlist.split(",")

    deck_card_list_array.each do |card_id|
      specific_card = MTG::Card.find(card_id)
      @deck_card_names.push(specific_card.name)
      @deck_card_images.push(specific_card.image_url)
    end

    @cards = MTG::Card.where(page: params[:page_num]).where(pageSize: 9).all
  end

  def search
    @deck = Deck.where(id: params[:id])
    @user = User.where(id: params[:user_id])
    if(params[:name] != "" && params[:card_color] == "" && params[:card_type] && params[:creature_type] == "" && params[:set] == "")
      @card = MTG::Card.where(name: params[:name])
      if(@card.length == 0)
        @card = "None found"
      end
    elsif(params[:name] != "" && params[:card_color] != "" && params[:creature_type] == "")
      temp = MTG::Card.where(name: params[:name])
      @card = []
      if temp.length != 0
        if(@card.colors.include?(params[:card_color]))
          for i in 0...temp.length
            if temp[i].colors.include?(params[:card_color])
              @card.push(temp[i])
            end
          end
        else
          @card = "None found"
        end
      end

    end
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
