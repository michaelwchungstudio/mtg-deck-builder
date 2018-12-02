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
    card_id = params[:card_id]
    deck_id = params[:deck_id]

    @deck = Deck.find(2)

    @deck.cardlist += (card_id + ",")
    p @deck.cardlist
    @deck.save

    redirect_to "/"
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

  def show
  end

  def edit
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
    @user = User.where(id: params[:user_id]).first
    #@cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).where(set: params[:set]).where(page: params[:page_num]).where(pageSize: 9).all
    
    #the recirect page starts the template for how searches will be parsed by the controllers next action.
    #we'll decrypt the search with a chomp function and go from there.
    redirect_to "/users/#{ @user.id }/decks/#{ @deck.id }/result/#{params[:card_name].to_s}%/#{params[:card_color].to_s}%/#{params[:card_type].to_s}%/#{params[:creature_type].to_s}%/#{params[:set].to_s}%/1"
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

  def update
  end

  def destroy
  end

  private

  def deck_params
    params.require(:deck).permit(:name, :cardlist, :user_id)
  end


end
