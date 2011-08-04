class VotesController < InheritedResources::Base

  before_filter :relog_user!
	respond_to :xml, :json, :js
  respond_to :js, :only => :create
  #after_filter :send_to_pusher

  def create
    @vote = Vote.new(params[:vote])
    @vote.user = current_user
    @vote.user_id ||= session["fbtoken"]
    @vote.user_id ||= User.last
    @message = @vote.message
    if Vote.where(:user_id => @vote.user_id, :message_id => @vote.message_id).all.empty?
      logger.info "Ok"
      create!
    end
  end

  def relog_user!
    unless current_user
        if session["fbtoken"]
          resource = User.find_by_facebook_token(session["fbtoken"])
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

end
