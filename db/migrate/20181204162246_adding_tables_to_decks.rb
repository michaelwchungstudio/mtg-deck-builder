class AddingTablesToDecks < ActiveRecord::Migration[5.2]
  def change
  	add_column :decks, :imageurls, :string
  	add_column :decks, :cardtypes, :string
  	add_column :decks, :cardnames, :string
  end
end
