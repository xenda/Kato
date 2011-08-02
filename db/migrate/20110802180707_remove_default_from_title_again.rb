class RemoveDefaultFromTitleAgain < ActiveRecord::Migration
  def self.up
    change_column :messages, :title, :string, :null => false, :default => ""
  end

  def self.down
  end
end
