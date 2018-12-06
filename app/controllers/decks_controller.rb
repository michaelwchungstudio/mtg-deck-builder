class DecksController < ApplicationController
  require 'faraday'
  require 'json'

  # ? - Manny's variable (?)
  $set = MTG::Set.all
  $type = MTG::Type.all
  $creaturetype = MTG::Subtype.all

  # List of all decks with the corresponding user creator
  # Clicking a deck leads to that deck's show page
  # Clicking a user leads to that user's profile page of his/her decks
  def index
    @decks = Deck.all
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
    card = MTG::Card.where(id: card_id).all
    card = card[0]
    deck_id = params[:deck_id]
    number = params[:quantity].to_i
    @deck = Deck.find(deck_id)

    for i in 1..number
      @deck.cardlist += (card_id + ",")
      @deck.cardtypes += (card.type + ",")
      if card.image_url != nil
        @deck.imageurls += (card.image_url + ",")
      else
        @deck.imageurls += ("nil,")
      end
      @deck.cardnames += (card.name + "%")
    end
    @deck.save

    redirect_back(fallback_location: root_path)
    #redirect_to "/users/#{@user.id}/decks/#{@deck.id}/edit/1"
  end

  def edit
    appID = "kylehamp-magic-PRD-660bef6c5-3442e159"

    @deck = Deck.where(id: params[:id]).first
    @user = current_user

    @deck_card_names = @deck.cardnames.split("%")
    @deck_card_images = @deck.imageurls.split(",")

    deck_card_list_array = @deck.cardlist.split(",")

    # deck_card_list_array.each do |card_id|
    #   specific_card = MTG::Card.find(card_id)
    #   @deck_card_names.push(specific_card.name)
    #   @deck_card_images.push(specific_card.image_url)
    # end
    @card_list_hash = parseDeckToHash(@deck)
    @image_set_string = parseDeckImages(@deck)
    @image_set_array = @image_set_string.split(",")

    @user = User.where(id: params[:user_id]).first
    #@pagenum will hold the number and be edited on the webpage for link usage
    @pagenum = params[:page_num]
    #@cards will display all the cards in the game based on the page number and how many we want to display.
    @cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtypes: params[:creature_type].to_s).where(set: params[:set]).where(page: params[:page_num]).where(pageSize: 9).all

    @card_price = []

    #eBay functionality
    for card in @cards
      searchTerm = card.name + " mtg"
      ebay = 'https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SECURITY-APPNAME=' + appID +'&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemFilter.paramName=Currency&itemFilter.paramValue=USD&keywords=' + searchTerm

      faraday = Faraday.new(url: ebay) do |f|
                  f.request :url_encoded
                  f.adapter :net_http
                  f.headers['Content-Type'] = 'application/json'
                  end

      response = faraday.get()

      value = JSON.parse(response.body)

      if value["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"] != nil
        @card_price.push(value["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"][0]["sellingStatus"][0]["currentPrice"][0]["__value__"])
      else
        @card_price.push("Unknown")
      end
    end
  end

  def search
    @deck = Deck.where(id: params[:deck_id]).first

    @user = current_user
    #@cards = MTG::Card.where(name: params[:card_name]).where(colors: params[:card_color]).where(type: params[:card_type]).where(subtype: params[:creature_type]).where(set: params[:set]).where(page: params[:page_num]).where(pageSize: 9).all

    #the redirect page starts the template for how searches will be parsed by the controllers next action.
    #we'll decrypt the search with a chomp function and go from there.
    redirect_to "/users/#{ @user.id }/decks/#{ @deck.id }/result/#{params[:card_name].to_s}%/#{params[:card_color].to_s}%/#{params[:card_type].to_s}%/#{params[:creature_type].to_s}%/#{params[:set].to_s}%/1"
  end

  def result
    appID = "kylehamp-magic-PRD-660bef6c5-3442e159"

    #These instance variable will hold the various parameters of the search that was concat by the search method
    @search_name = params[:search_name].chomp('%')
    @search_color = params[:search_color].chomp('%')
    @search_type = params[:search_type].chomp('%')
    @search_creature = params[:search_creature].chomp('%')
    @search_set = params[:search_set].chomp('%')
    @deck = Deck.where(id: params[:id]).first
    @user = current_user
    @cards = MTG::Card.where(name: @search_name).where(colors: @search_color).where(type: @search_type).where(subtypes: @search_creature).where(set: @search_set).where(page: params[:page_num]).where(pageSize: 9).all

    @card_list_hash = parseDeckToHash(@deck)
    @image_set_string = parseDeckImages(@deck)
    @image_set_array = @image_set_string.split(",")

    @pagenum = params[:page_num]

    @card_price = []

    #eBay functionality
    for card in @cards
      searchTerm = card.name + " mtg"
      ebay = 'https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SECURITY-APPNAME=' + appID +'&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemFilter.paramName=Currency&itemFilter.paramValue=USD&keywords=' + searchTerm

      faraday = Faraday.new(url: ebay) do |f|
                  f.request :url_encoded
                  f.adapter :net_http
                  f.headers['Content-Type'] = 'application/json'
                  end

      response = faraday.get()

      value = JSON.parse(response.body)

      if value["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"] != nil
        @card_price.push(value["findItemsByKeywordsResponse"][0]["searchResult"][0]["item"][0]["sellingStatus"][0]["currentPrice"][0]["__value__"])
      else
        @card_price.push("Unknown")
      end
    end
  end

  def show
    @deck = Deck.find(params[:id])

    @card_list_hash = parseDeckToHash(@deck)
    @image_set_string = parseDeckImages(@deck)
  end

  def removeCardFromDeck
    @deck = Deck.where(id: params[:deck_id]).first

    cardlist = @deck.cardlist.split(',')
    cardname = @deck.cardnames.split('%')
    cardimage = @deck.imageurls.split(',')
    cardtype = @deck.cardtypes.split(',')

    index = cardname.index(params[:card_name])

    cardlist.delete_at(index)
    cardname.delete_at(index)
    cardimage.delete_at(index)
    cardtype.delete_at(index)

    @deck.update(cardlist: cardlist.join(","), cardnames: cardname.join('%'), imageurls: cardimage.join(","), cardtypes: cardtype.join(","))
    @deck.save
    redirect_back(fallback_location: root_path)
  end

  def update
  end

  def destroy
    @deck = Deck.where(id: params[:deck_id]).first
    @deck.destroy

    @user = current_user

    redirect_to "/profile/#{@user.id}"
  end

  # Custom functions for specific data retrieval
  def parseDeckToHash(mtgdeck)
    deck_cardlist_array = mtgdeck.cardlist.split(",")
    deck_cardlist_names = mtgdeck.cardnames.split("%")
    deck_cardlist_types = mtgdeck.cardtypes.split(",")
    deck_cardlist_images = mtgdeck.imageurls.split(",")
    deck_hash = Hash.new{ |h, k| h[k] = [0, ""] }

    deck_cardlist_names.each_with_index do |cname, i|
        deck_hash[cname][0] += 1
        deck_hash[cname][1] = deck_cardlist_types[i]

        if deck_cardlist_images[i] == "nil"
          deck_hash[cname][2] = '/assets/mtg_cardback.jpg'
        else
          deck_hash[cname][2] = deck_cardlist_images[i]
        end
    end

    # Returns a hash with key value pair (card name => # of that card in deck)
    return deck_hash
  end

  def parseDeckImages(mtgdeck)
    require 'set'

    deck_cardlist_array = mtgdeck.cardlist.split(",")
    deck_cardlist_images = mtgdeck.imageurls.split(",")

    image_set = Set.new(deck_cardlist_images)
    image_set_string = ""

    image_set.each do |imglink|
      image_set_string += (imglink + ",")
    end

    # Returns a string of image_urls for a deck list (hashed)
    return image_set_string
  end

  ##################################

  private

  def deck_params
    params.require(:deck).permit(:name, :cardlist, :user_id, :imageurls, :cardtypes, :cardnames)
  end

end
