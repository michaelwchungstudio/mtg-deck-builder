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

    if params[:id] == nil #was having some issues with grabbing the deck id. So installed if statement to solve it.
      @deck = Deck.where(id: params[:deck_id]).first
    else
      @deck = Deck.where(id: params[:id]).first
    end
    @user = User.where(id: params[:user_id]).first
    #@pagenum will hold the number and be edited on the webpage for link usage
    @pagenum = params[:page_num]
    #@cards will display all the cards in the game based on the page number and how many we want to display.
    @cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).where(set: params[:set]).where(page: params[:page_num]).where(pageSize: 9).all

  end

  def search
    @deck = Deck.where(id: params[:deck_id]).first

    @user = current_user
    #@cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).where(set: params[:set]).where(page: params[:page_num]).where(pageSize: 9).all

    #the redirect page starts the template for how searches will be parsed by the controllers next action.
    #we'll decrypt the search with a chomp function and go from there.
    redirect_to "/users/#{ @user.id }/decks/#{params[:deck_id]}/result/#{params[:card_name].to_s}%/#{params[:card_color].to_s}%/#{params[:card_type].to_s}%/#{params[:creature_type].to_s}%/#{params[:set].to_s}%/1"
    #redirect_back(fallback_location: root_path)
  end

  def result
    #These instance variable will hold the various parameters of the search that was concat by the search method
    @search_name = params[:search_name].chomp('%')
    @search_color = params[:search_color].chomp('%')
    @search_type = params[:search_type].chomp('%')
    @search_creature = params[:search_creature].chomp('%')
    @search_set = params[:search_set].chomp('%')

    @pagenum = params[:page_num]
    @cards = MTG::Card.where(name: @search_name).where(colors: @search_color).where(type: @search_type).where(subtype: @search_creature).where(set: @search_set).where(page: params[:page_num]).where(pageSize: 9).all
  end

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
