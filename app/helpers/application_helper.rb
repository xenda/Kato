module ApplicationHelper

  def fb_token
   current_user ? current_user.facebook_token : cookies.permanent["fbtoken"]
  end

end
