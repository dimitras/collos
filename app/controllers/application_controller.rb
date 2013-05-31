class ApplicationController < ActionController::Base
    protect_from_forgery
    helper_method :current_user
    before_filter :require_login
    check_authorization

    private

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def require_login
        unless current_user
            flash[:error] = "You must be logged in to access this section"
            redirect_to login_url # halts request cycle
        end
    end

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url, :alert => exception.message
    end

end
