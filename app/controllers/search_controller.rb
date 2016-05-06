class SearchController < ApplicationController

	skip_authorization_check

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
			format.csv do
				#res = []
				#@results.each do |result|
				#	res << [result.searchable.name, result.searchable.barcode_string]
				#end
				#send_data res.to_csv
				send_data formatted_results
			end
			#format.csv {send_data @results.to_csv}
			#format.csv {send_data @results.map(&:result)}
			#format.csv { render file: 'search/fetch.csv.haml', content_type: "text/csv", filename: "#{params[:query]}.csv"}
		end
	end

	private
	helper_method :formatted_results
	def formatted_results
		res = []
		@results.each do |result|
			res << [result.searchable.name, result.searchable.barcode_string].to_csv
		end
		return res.to_csv
	end

end
