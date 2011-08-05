class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:devise_oauth2_canvas_facebook

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :messages
  has_many :votes

  NINJAS = ['674537928']
  
  def update_facebook_user(fb_user, client, options)
    self.name = fb_user.name.to_s.downcase if fb_user.name.present?
  end
  
  
end
