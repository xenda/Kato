class VotesController < InheritedResources::Base

  #before_filter :relog_user!
	respond_to :xml, :json, :js
  respond_to :js, :only => :create
  #after_filter :send_to_pusher

  before_filter :setup_code
  before_filter  :set_p3p

  #after_filter :update_votes_count

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




  def fb_token
   current_user ? current_user.facebook_token : cookies.permanent["fbtoken"]
  end

  def create
    @vote = Vote.new(params[:vote])
    @vote.token = fb_token
    @vote.user = current_user
    @vote.user_id ||= cookies.permanent["fbtoken"]
    @vote.user_id ||= User.last
    @message = @vote.message
    if Vote.where(:token => fb_token, :message_id => @vote.message_id).all.empty?
      logger.info "Ok"
      #create!
      render :nothing => true
    else
      render :nothing => true
    end
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

  def send_to_pusher
    if @vote.errors.empty?
      @message.reload
      Pusher['alpha-skunk'].trigger!('vote:create', {:message_id => @vote.message_id, :votes_count => @message.votes_count})
    end
  end
=begin
  def update_votes_count
    if message = Message.find(@vote.message_id)
      message.votes_count = Vote.where(:message_id => @vote.message_id).count
      message.save
    end
  end
=end
end
