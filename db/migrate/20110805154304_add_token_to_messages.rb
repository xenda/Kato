class AddTokenToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :token, :string
  end

  def self.down
    remove_column :messages, :token
  end
end
