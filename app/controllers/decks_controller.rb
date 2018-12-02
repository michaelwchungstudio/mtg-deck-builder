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
    if params[:id] == nil
      @deck = Deck.where(id: params[:deck_id]).first
    else
      @deck = Deck.where(id: params[:id]).first
    end
    @user = User.where(id: params[:user_id]).first
    @pagenum = params[:page_num]
    @cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).where(set: params[:set]).where(page: params[:page_num]).where(pageSize: 9).all
      
  end

  def search
    @deck = Deck.where(id: params[:deck_id]).first
    @user = User.where(id: params[:user_id]).first
    @cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).where(set: params[:set]).where(page: params[:page_num]).where(pageSize: 9).all
    redirect_to "/users/#{ @user.id }/decks/#{ @deck.id }/result/#{params[:card_name].to_s}%/#{params[:card_color].to_s}%/#{params[:card_type].to_s}%/#{params[:creature_type].to_s}%/#{params[:set].to_s}%/1"
    #redirect_back(fallback_location: root_path)
  end
  def result
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
