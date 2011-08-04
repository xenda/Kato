class AddTokenToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :token, :string
  end

  def self.down
    remove_column :votes, :token
  end
end
