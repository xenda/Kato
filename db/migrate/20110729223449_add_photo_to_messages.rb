class AddPhotoToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :photo_file_name, :string
    add_column :messages, :photo_file_size, :integer
    add_column :messages, :photo_updated_at, :datetime
    add_column :messages, :photo_content_type, :string
  end

  def self.down
    remove_column :messages, :photo_content_type
    remove_column :messages, :photo_updated_at
    remove_column :messages, :photo_file_size
    remove_column :messages, :photo_file_name
  end
end
