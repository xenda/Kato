module ApplicationHelper

  def fb_token
   current_user ? current_user.facebook_token : session["fbtoken"]
  end

end
