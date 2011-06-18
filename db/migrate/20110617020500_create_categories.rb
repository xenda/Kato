class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, :null => false
      t.string :banner_file_name
      t.integer :banner_file_size
      t.datetime :banner_updated_at
      t.string :banner_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
