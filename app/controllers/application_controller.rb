class ApplicationController < ActionController::Base

    def authenticated?
        !current_user.blank?
    end

    def fb_auth_client
      @fb_auth ||= FbGraph::Auth.new("136578643087393", "4d543e7427a437b03fecef6618ce0585")        
    end
    
    

    protect_from_forgery

    rescue_from FbGraph::Exception, :with => :fb_graph_exception

    def fb_graph_exception(e)
      flash[:error] = {
        :title   => e.class,
        :message => e.message
      }
      current_user.try(:destroy)
      redirect_to root_url
    end
    
    
end
