class HomeController < ApplicationController
  # include Devise::Controllers::InternalHelpers
  # include DeviseOauth2CanvasFacebook::FacebookConsumerHelper

  def index
    @message = Message.new
    @messages = Message.published.order("created_at DESC").limit(6).all
    if current_user
      cookies.permanent["fbtoken"] = current_user.facebook_token if current_user.facebook_token.present?
    end

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
          if resource && User.respond_to?(:serialize_into_cookie)
            resource.remember_me!
            cookies.signed["remember_user_token"] = {
              :value => User.serialize_into_cookie(resource),
              :expires => resource.remember_expires_at,
              :path => "/"
            }
          # logger.info cookies.signed["remember_#{resource_name}_token"].inspect
          end
          sign_in("users", resource) if resource
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

  def terms

  end

  def facebook
    render :layout => 'facebook'
  end

end
