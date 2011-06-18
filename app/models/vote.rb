class Vote < ActiveRecord::Base
  
  belongs_to :message, :counter_cache => true
  belongs_to :user
  
end
