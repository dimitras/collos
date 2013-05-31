class PagesController < ApplicationController
    skip_before_filter :require_login

    caches_page :index,:help,:about,:contact
    def index; end
    def help; end
    def about; end
    def contact; end
end
