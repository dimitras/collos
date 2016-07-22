class SearchController < ApplicationController

	skip_authorization_check

    def index
        authorize! :index, PgSearch::Document
        @results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per_page(params[:per_page] || 25)
        
        ## results withouts tubes, but without pagination
        #@results = PgSearch.multisearch(params[:query]).reject{|r| r.searchable_type == "Container" and !r.searchable.container_type.can_have_children}.page(params[:page] || 1).per_page(params[:per_page] || 25)

=begin
        @results = PgSearch.multisearch(params[:query]).all
        @results.reject! do |result|
			!result.searchable.container_type.can_have_children
		end
		@results.page(params[:page] || 1).per_page(params[:per_page] || 25)
=end
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
		end
	end

	private
	helper_method :formatted_results
	def formatted_results
		res = []
		PgSearch.multisearch(params[:query]).all.each do |result|
			rs = result.searchable
			rst = result.searchable_type
			if rst == "Sample"
				res << [rst, rs.name, rs.barcode_string, rs.scientific_name, rs.source_name, rs.tissue_type_name, rs.replicate, rs.treatments, rs.time_point, rs.study_titles, rs.container.ancestors[0]]
			elsif rst == "Container" && rs.container_type.can_have_children
				res << [rst, rs.name, rs.barcode_string, rs.container_type_name, rs.parent]
			elsif rst == "Study" || rst == "Investigation"
				res << [rst, rs.title, rs.identifier, rs.description]
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
