class RemoveDefaultFromTitle < ActiveRecord::Migration
  def self.up
    change_column :messages, :title, :string, :null => false
  end

  def self.down
  end
end
