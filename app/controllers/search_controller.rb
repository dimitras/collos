class SearchController < ApplicationController

    def index
        authorize! :index, PgSearch::Document
        @results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per_page(params[:per_page] || 25)
    end
end
