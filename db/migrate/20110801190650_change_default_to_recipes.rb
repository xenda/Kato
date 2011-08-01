class ChangeDefaultToRecipes < ActiveRecord::Migration
  def self.up
    change_column :messages, :title, :string, :default => "Mi receta...", :null => false
  end

  def self.down
  end
end
