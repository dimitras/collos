class PagesController < ApplicationController
    	skip_before_filter :require_login
    	skip_authorization_check

    	caches_page :index,:help,:about,:contact
    	def index; end
    	def help; end
    	def about; end
    	def contact; end

    	# TOFIX
    	def upload_isatab
		path = File.join("public/isatabs", upload["datafile"].original_filename)
		File.open(path, "wb") { |f| f.write(upload["datafile"].read) }
	end

	def upload_csv
		path = File.join("public/csvs", upload["datafile"].original_filename)
		File.open(path, "wb") { |f| f.write(upload["datafile"].read) }
	end

	#TODO!!!!
	#def file_uploaded
	#	require 'fileutils'
	#	tmp = params[:file_upload][:my_file].tempfile
	#	file = File.join("public", params[:file_upload][:my_file].original_filename)
	#	FileUtils.cp tmp.path, file
	#	#...	
	#	FileUtils.rm file
	#end

	# "public/csv" is the directory you want to save the files in
	# # upload["datafile"] is the data populated by the file input tag in your html form 
	# path = File.join("public/csv", upload["datafile"].original_filename)
	# File.open(path, "wb") { |f| f.write(upload["datafile"].read) }
end
