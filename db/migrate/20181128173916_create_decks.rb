class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.string :name
      t.string :cardlist
      t.integer :user_id

      t.timestamps
    end
  end
end
