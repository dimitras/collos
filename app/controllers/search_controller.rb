class SearchController < ApplicationController

	skip_authorization_check

    def index
        authorize! :index, PgSearch::Document
        @results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per_page(params[:per_page] || 25)

        respond_to do |format|
        	format.html
			format.csv {send_data formatted_results, :filename => "#{params[:query]}_results.csv"}
		end
    end

	def fetch
	    if params[:all]
	    	@results = PgSearch.multisearch(params[:query]).all
	    else
	    	@results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per_page(params[:per_page] || 25)
	    end

		respond_to do |format|
			format.html
			#format.csv {send_data @results.to_csv, :filename => "#{params[:query]}.csv"}
			#format.csv {send_data formatted_results}#.each_with_index {|val,idx| p "#{val} => #{idx}"} }
=begin
			format.csv do
				#res = []
				#@results.each do |result|
				#	res << [result.searchable.name, result.searchable.barcode_string]
				#end
				#send_data res.to_csv
				send_data formatted_results
			end
=end
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
			if result.searchable_type == "Sample"
				res << [result.searchable_type, result.searchable.name, result.searchable.barcode_string, result.searchable.scientific_name, result.searchable.source_name, result.searchable.tissue_type_name, result.searchable.replicate, result.searchable.treatments, result.searchable.time_point, result.searchable.study_titles, result.searchable.container.ancestors[0]]
			elsif result.searchable_type == "Container" #&& result.searchable.with_children == true
				res << [result.searchable_type, result.searchable.name, result.searchable.barcode_string, result.searchable.container_type_name, result.searchable.parent]
			elsif result.searchable_type == "Study" || result.searchable_type == "Investigation"
				res << [result.searchable_type, result.searchable.title, result.searchable.identifier, result.searchable.description]
			end
		end
		str = CSV.generate do |csv|
			res.each do |r|
				csv << r
			end
		end
		return str
	end

end
