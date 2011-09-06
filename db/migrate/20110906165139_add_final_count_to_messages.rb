class AddFinalCountToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :final_count, :integer

    Message.published.all.each do |m|
		votes = m.votes.valid.count
		m.final_count = votes
		m.save
	end

  end

  def self.down
    remove_column :messages, :final_count
  end
end
