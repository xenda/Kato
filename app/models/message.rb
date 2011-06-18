class Message < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :category
  validates_presence_of :category_id, :on => :create, :message => "can't be blank"
  validates_presence_of :title, :on => :create, :message => "can't be blank"
end
