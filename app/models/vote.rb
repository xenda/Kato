class Vote < ActiveRecord::Base
  
  belongs_to :message, :counter_cache => true
  belongs_to :user

  scope :valid, where(:created_at => Date.parse("14/02/2011")...Date.parse("02/09/2011"))
  
end
