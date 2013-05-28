class PagesController < ApplicationController
    caches_page :index,:help,:about,:contact
    def index; end
    def help; end
    def about; end
    def contact; end
end
