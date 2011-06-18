class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :user
      t.string :title, :default => "Mi idea", :null => false
      t.text :content, :default => ""
      t.references :category, :null => false
      t.integer :votes_count, :default => 0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
