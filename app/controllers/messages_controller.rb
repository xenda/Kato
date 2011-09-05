class MessagesController < InheritedResources::Base

  #before_filter :relog_user!
  #after_filter :send_to_pusher, :only => :create
  before_filter :load_most_voted
  before_filter :setup_code
  before_filter  :set_p3p

  def set_p3p
    response.headers["P3P"]='CP="CAO PSA OUR"'
  end


  def setup_code


     if params[:signed_request]
      fb_auth_client.from_signed_request(params[:signed_request])
      if fb_auth_client.authorized?
        # If authorized, the auth has user and access_token.
        # redirect_to user_fb_auth_path unless current_user
        unless current_user
          @data = fb_auth_client.data
          logger.info @data["user"].inspect
          user = @data["user_id"]
          token = @data["oauth_token"]

          resource = User.find_by_facebook_uid(user)
          if User.respond_to?(:serialize_into_cookie)
            resource.remember_me!
            cookies.signed["remember_user_token"] = {
              :value => User.serialize_into_cookie(resource),
              :expires => resource.remember_expires_at,
              :path => "/"
            }
          # logger.info cookies.signed["remember_#{resource_name}_token"].inspect
          end
          sign_in("users", resource)
          # set_flash_message :notice, :signed_in
        end

        @data = fb_auth_client.data
        logger.info @data["user"].inspect
        user = @data["user_id"]
        token = @data["oauth_token"]
        cookies.permanent["fbtoken"] = token

      else
        # First time user, show "Connect" button here.
        redirect_to user_fb_auth_path
        # @data = auth.data
      end
    end

  end


  def create
    create! {
      @message.token = fb_token
      @message.save
      @message.ingredients.each do |ingredient|
        ingredient.message = @message
        ingredient.save
      end
      message_path(@message)
    }
  end

  def index
    @message = Message.new
    @messages = Message.published.order("created_at DESC").page(params[:page]).per(16)  #order("created_at DESC").paginateall
    render "index", :layout => "messages_list"
  end

  def show
    @message = Message.find(params[:id])
    render :show, :layout => "open_graph"
  end

  def new
    @message = Message.new
    5.times{ @message.ingredients.build }
    new!
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
      flash[:not_found] = "Lo sentimos, Usted no es cliente de Cuenta Ganadora, Mundo Sueldo o Tarjeta de Cr&eacute;dito."
      render :add
    end
  end

  def publish
    @message = Message.find(params[:id])
    @message.published = true
    @message.save
    flash[:published] = "Felicitaciones tu receta se subi&oacute; exitosamente. Ahora espera nuestra confirmaci&oacute;n para invitar a tus amigos a votar."
    redirect_to message_path(@message)
  end

  def relog_user!
    unless current_user
        if cookies.permanent["fbtoken"]
          resource = User.find_by_facebook_token(cookies.permanent["fbtoken"])
          if resource
            if User.respond_to?(:serialize_into_cookie)
              resource.remember_me!
              cookies.signed["remember_user_token"] = {
                :value => User.serialize_into_cookie(resource),
               :expires => resource.remember_expires_at,
               :path => "/"
             }
             # logger.info cookies.signed["remember_#{resource_name}_token"].inspect
            end
            sign_in("users", resource)
            # set_flash_message :notice, :signed_in
          end
      end
    end
    authenticate_user!
  end

  private

  def fb_token
   current_user ? current_user.facebook_token : cookies.permanent["fbtoken"]
  end

  def load_most_voted
    @most_voted = Message.most_voted.all
  end


  def send_to_pusher
    if @message.errors.empty?
      Pusher['alpha-skunk'].trigger!('message:create', {:id => @message.id, :title => @message.title, :content => @message.content, :votes_count => @message.votes_count})
    end
  end

end
