class SearchController < ApplicationController

    def index
        authorize! :index, PgSearch::Document
        @results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per_page(params[:per_page] || 25)
    end

    def fetch
	    if params[:all]
	    	@results = PgSearch.multisearch(params[:query]).all
	    else
	    	@results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per_page(params[:per_page] || 25)
	    end

		respond_to do |format|
			format.html
			format.csv { render file: 'search/fetch.csv.haml', content_type: "text/csv", filename: "#{params[:query]}.csv"}
		end
	end
end
