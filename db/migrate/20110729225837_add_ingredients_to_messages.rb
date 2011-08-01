class AddIngredientsToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :ingredients, :text
  end

  def self.down
    remove_column :messages, :ingredients
  end
end
