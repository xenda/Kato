class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.string :document_type
      t.string :document_number
      t.string :middle_name
      t.string :last_name

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
