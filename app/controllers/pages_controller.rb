class PagesController < ApplicationController
    skip_before_filter :require_login
    skip_authorization_check

    caches_page :index,:help,:about,:contact
    def index; end
    def help; end
    def about; end
    def contact; end

 #    # TOFIX
 #    def upload_isatab
	# 	path = File.join("public/isatabs", upload["datafile"].original_filename)
	# 	File.open(path, "wb") { |f| f.write(upload["datafile"].read) }
	# end

	# def upload_csv
	# 	path = File.join("public/csvs", upload["datafile"].original_filename)
	# 	File.open(path, "wb") { |f| f.write(upload["datafile"].read) }
	# end
end
