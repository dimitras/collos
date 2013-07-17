class SessionsController < ApplicationController
  skip_before_filter :require_login
  skip_authorization_check

  def new
  end

  def create
    raise request.env["omniauth.auth"].to_yaml
    logger.debug(env["omniauth.auth"])
    begin
      user = User.from_omniauth(env["omniauth.auth"])
      if user.pending?
        flash[:success] = "User #{user.name} is now pending. We will send you an email once your account is active."
        redirect_to root_path and return
      else
        session[:user_id] = user.id
        redirect_to env['omniauth.origin'], notice: "Signed in!"
      end
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
