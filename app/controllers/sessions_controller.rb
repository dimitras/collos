class SessionsController < ApplicationController
  skip_before_filter :require_login
  skip_authorization_check

  def new
  end

  def create
    # raise request.env["omniauth.auth"].to_yaml
    logger.debug(env["omniauth.auth"])
    begin
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Signed in!"
    rescue OmniAuth::Error => e
      redirect_to login_url, alert:  "Authentication failed, please try again.", params: params
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to login_url, alert: "Authentication failed, please try again."
  end
end
