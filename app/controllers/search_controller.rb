class SearchController < ApplicationController
    def search
        @results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per_page(params[:per_page] || 25)
    end
end
