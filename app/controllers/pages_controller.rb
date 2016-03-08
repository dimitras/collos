require 'fileutils'

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

	def file_upload
		name = file_upload["my_file"]
		directory = "public"
		path = File.join(directory,"uploads", name.original_filename) #.tempfile.path)
		#upload_file = File.new(file_upload["my_file"], "rb").read
		File.open(path,"wb") {|f| f.write(name.read)} #; f.close}
	end

	def upload 
		uploaded_io = params[:file]
		File.open(Rails.root.join('workspace', 'uploads',uploaded_io.original_filename), 'wb') do |file|
			file.write(uploaded_io.read)
			respond_to do |format|
				format.html { redirect_to(root_url, :notice => 'File was uploaded.') }
			end
		end
	end

end
