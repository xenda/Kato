class ApplicationController < ActionController::Base

  before_filter :load_most_voted

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
    logger.info e.message
    #current_user.try(:destroy)
    redirect_to root_url
  end

  private

  def load_most_voted
    @most_voted = Message.most_voted.all
  end



end
