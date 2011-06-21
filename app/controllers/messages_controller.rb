class MessagesController < InheritedResources::Base
  
  before_filter :authenticate_user!
  after_filter :send_to_pusher
  
  def create
    create! { root_path }
  end
  
  def index
    @message = Message.new
    @messages = Message.all
  end
  
  private
  
  def send_to_pusher
    if @message.errors.empty?
      Pusher['alpha-kato'].trigger!('message:create', @message.attributes)
    end
  end
  
end
