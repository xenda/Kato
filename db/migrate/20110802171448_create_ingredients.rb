class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.integer :message_id
      t.string :quantity
      t.string :ingredient_type
      t.string :product

      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients
  end
end
