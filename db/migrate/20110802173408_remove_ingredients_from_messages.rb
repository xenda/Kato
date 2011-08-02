class RemoveIngredientsFromMessages < ActiveRecord::Migration
  def self.up
    remove_column :messages, :ingredients
  end

  def self.down
  end
end
