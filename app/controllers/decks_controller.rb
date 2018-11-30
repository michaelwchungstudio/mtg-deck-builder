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


  def show
  end

  def edit
    p params
    @deck = Deck.where(id: params[:id]).first
  end

  def search
    @deck = Deck.where(id: params[:id])
    @user = User.where(id: params[:user_id])
            @card = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).all
            p @card
    
    if(params[:card_name] != "")
      if(params[:card_color] != "")
        if (params[:card_type] != "")
          if (params[:creature_type] != "")
            if(params[:set] != "")

            #else

            end
          #else

          end

        #else
          
        end

      #else

      end

    #else
      # if(params[:card_color] != "")
      #   if (params[:card_type] != "")
      #     if (params[:creature_type] != "")
              # if (params[:set] != "")

              # else
                
              # end

      #     else

      #     end

      #   else
          
      #   end

      # else

      # end
    end

    #if(params[:name] != "" && params[:card_color] == "" && params[:card_type] && params[:creature_type] == "" && params[:set] == "")


    #   @card = MTG::Card.where(name: params[:name])
    #   if(@card.length == 0)
    #     @card = "None found"
    #   end
    # elsif(params[:name] != "" && params[:card_color] != "" && params[:creature_type] == "")
    #   temp = MTG::Card.where(name: params[:name]).where(colors: params[:card_color])
    #   @card = []
    #   if temp.length != 0
    #     @card = temp
    #   else
    #     @card = "None found"
    #   end 
    # elsif( params[:name] != "" && params[:card_color] == "" && params[:creature_type] != "")
    #   temp = MTG::Card.where(name: )
    
     #end
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
