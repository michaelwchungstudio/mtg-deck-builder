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
    @deck = Deck.where(id: params[:id]).first
<<<<<<< HEAD
    @user = User.where(id: params[:user_id]).first
    p params[:page_num]
    @pagenum = params[:page_num]
    @cards = MTG::Card.where(page: params[:page_num]).where(pageSize: 9).all
=======
    @user = current_user
>>>>>>> 78e9b1ed8e0f3445e62302a44e357a23810131ff
  end

  def search
    @deck = Deck.where(id: params[:deck_id]).first
    @user = User.where(id: params[:user_id]).first
    if(params[:card_name] == "" && params[:card_color] == "" && params[:card_type] == "" && params[:creature_type] == "" && params[:set] == "")
      @cards = MTG::Card.where(page: 1).where(pageSize: 9).all
      redirect_to "/users/#{ @user.id }/decks/#{ @deck.id }/edit/1"
    else
      @cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).where(set: params[:set]).all
      redirect_to "/users/#{ @user.id }/decks/#{ @deck.id }/result"
    end

    #redirect_back(fallback_location: root_path)
  end
  def result
    @deck = Deck.where(id: params[:id]).first
    @user = User.where(id: params[:user_id]).first
  end

  def update
  end

  def destroy
  end

  private

  def deck_params
    params.require(:deck).permit(:name, :cardlist, :user_id)
  end
<<<<<<< HEAD
  def deck_params2
    params.require(:deck).permit(:user_id, :deck_id, :page_num)
  end
=======
>>>>>>> 78e9b1ed8e0f3445e62302a44e357a23810131ff

end
