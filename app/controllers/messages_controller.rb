class MessagesController < InheritedResources::Base
  
  before_filter :authenticate_user!
  
  
  def create
    create! { root_path }
  end
  
  def index
    @message = Message.new
    @messages = Message.all
  end
  
end
