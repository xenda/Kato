class MessagesController < InheritedResources::Base

  # before_filter :authenticate_user!
  #after_filter :send_to_pusher, :only => :create
  before_filter :load_most_voted

  def create
    create! { root_path }
  end

  def index
    @message = Message.new
    @messages = Message.order("created_at DESC").all
  end

  def show
    @message = Message.find(params[:id])
    render :show, :layout => "open_graph"
  end

  def add
    @message = Message.new
    @messsages = Message.order("created_at DESC").all
    redirect_to new_message_path if session[:valid_user]
  end

  def verify
    if Message.validate_user(params[:message][:dni])
    redirect_to new_message_path
    else
      @message = Message.new(params[:message])
      flash[:notice] = "No te encontramos en nuestra base de datos"
      render :add
    end
  end

  private

  def load_most_voted
    @most_voted = Message.most_voted.all
  end


  def send_to_pusher
    if @message.errors.empty?
      Pusher['alpha-skunk'].trigger!('message:create', {:id => @message.id, :title => @message.title, :content => @message.content, :votes_count => @message.votes_count})
    end
  end

end
