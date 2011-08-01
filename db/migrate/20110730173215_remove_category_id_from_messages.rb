class RemoveCategoryIdFromMessages < ActiveRecord::Migration
  def self.up
    remove_column :messages, :category_id
  end

  def self.down
  end
end
