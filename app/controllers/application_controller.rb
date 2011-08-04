class ApplicationController < ActionController::Base

  before_filter :load_most_voted

  def authenticated?
      !current_user.blank?
  end

  def fb_auth_client
    @fb_auth ||= FbGraph::Auth.new("136578643087393", "4d543e7427a437b03fecef6618ce0585")
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

  protect_from_forgery

  rescue_from FbGraph::Exception, :with => :fb_graph_exception

  def fb_graph_exception(e)
    flash[:error] = {
      :title   => e.class,
      :message => e.message
    }
    logger.info e.message
    #current_user.try(:destroy)
    redirect_to root_url
  end

  private

  def load_most_voted
    @most_voted = Message.most_voted.all
  end



end
