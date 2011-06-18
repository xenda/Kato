class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :user, :null => false
      t.references :message, :null => false
      t.boolean :spam, :default => false, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
