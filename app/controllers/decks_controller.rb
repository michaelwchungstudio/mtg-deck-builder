class DecksController < ApplicationController

  # ? - Manny's variable (?)
  $set = MTG::Set.all

  # List of all decks with the corresponding user creator
  # Clicking a deck leads to that deck's show page
  # Clicking a user leads to that user's profile page of his/her decks
  def index
    @user = current_user
    @decks = Deck.where(user_id: @user.id)
  end

  # Create a new deck - text input with a deck name
  # Leads to deck edit page
  def new
    @deck = Deck.new
  end

  # POST action - saves the deck with input name
  def create
    @user = current_user
    deck = Deck.new(deck_params)
    if deck.save
      redirect_to "/users/#{@user.id}/decks/#{deck.id}/edit/1"
    else
      redirect_to "/users/#{@user.id}/decks/new"
    end
  end

  # Custom POST action called upon clicking a card's 'add to deck' button
  # Retrieves the card_id through a hidden field and adds it to the deck's string property 'cardlist'
  def addCardToDeck
    @user = current_user
    card_id = params[:card_id]
    deck_id = params[:deck_id]

    @deck = Deck.find(deck_id)

    @deck.cardlist += (card_id + ",")

    @deck.save

    redirect_to "/users/#{@user.id}/decks/#{@deck.id}/edit/1"
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

  # Show a specific deck's cards
  def show
    require 'set'

    @deck = Deck.find(params[:id])

    # this repeats from edit action - perhaps create custom func (needs more DRY)
    @deck_card_names = []
    @deck_card_images = []

    deck_card_list_array = @deck.cardlist.split(",")
    @card_list_hash = Hash.new(0)

    deck_card_list_array.each do |card_id|
      if specific_card = MTG::Card.find(card_id)
        @deck_card_names.push(specific_card.name)
        @deck_card_images.push(specific_card.image_url)
      end
    end

    @image_set = Set.new(@deck_card_images)
    @image_set_string = ""

    @deck_card_names.each do |cardname|
      @card_list_hash[cardname] += 1
    end

    @image_set.each do |imagelink|
      @image_set_string += (imagelink + ",")
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
