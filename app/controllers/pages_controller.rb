class PagesController < ApplicationController
    skip_before_filter :require_login
    skip_authorization_check

    caches_page :index,:help,:about,:contact
    def index; end
    def help; end
    def about; end
    def contact; end
end
