require 'fileutils'
require 'thread'

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
		redirect_to(root_url)
		if uploaded_io
			fname = uploaded_io.original_filename
			pname = "#{Rails.root}/workspace/uploads/#{fname}"
			File.open(Rails.root.join('workspace', 'uploads', fname), 'wb') do |file|
				if fname.downcase.end_with?('.xlsx','.xls')
					file.write(uploaded_io.read)
					#redirect_to(root_url, :notice => "#{fname} is submitted for import.")
					job_id = PagesWorker.perform_async(pname)
					flash[:notice] = "#{job_id} is being processed..."
=begin	
					que = Sidekiq::Queue.new("high")
					while que.size != 0
						flash[:notice] = "#{job_id} is being processed..."
						break if que.size == 0
					end
					flash[:notice] = "#{job_id} finished."

=begin
					status = Sidekiq::Status::status(job_id)
					while status
						flash[:notice] = "#{job_id} is being processed..."
						status = Sidekiq::Status::status(job_id)
						break if status.nil?
					end
					flash[:notice] = "#{job_id} finished."
=begin
					loop do
						job_status = Sidekiq::Status::complete? job_id
						break if job_status == true
					end
					flash[:success] = "Data imported successfully!"
=begin					
					Thread.new do 
						sleep(5)
						flash[:notice] = Sidekiq::Status::complete? job_id
						#finished = Sidekiq::Status::complete? job_id
						#case finished
						#when TRUE
						#	flash[:success] = "Data imported successfully!"
						#when FALSE
						#	flash[:notice] = "Almost done..."
						#end
					end
=end
					#system "rake db:import_data UPFILE=#{Rails.root}/workspace/uploads/#{uploaded_io.original_filename} --trace >> #{Rails.root}/workspace/uploads/#{uploaded_io.original_filename}.log &"
				else
					flash[:alert] = "Inappropriate format (#{fname}). Use .xlsx, .xls formats."
					#redirect_to(root_url, :notice => "Inappropriate file format (#{fname}). Use .xlsx, .xls formats.")
				end
			end
		else
			flash[:notice] = "Choose your data file first."
			#redirect_to(root_url, :notice => "Choose your data file first.")
		end
	end

=begin
	def sidekiq_stats()
		summary = Hash.new
		stats = Sidekiq::Stats.new
		summary = { processed: stats.processed, failed: stats.failed, enqueued: stats.enqueued, queues: stats.queues}
	end

	def queue_stats(queue)
		summary = Hash.new
		queue = Sidekiq::Queue.new(queue)
		summary = { size: queue.size, latency: queue.latency}
	end
=end
	def finished#(job_id)
		redirect_to(root_url)
		queue = Sidekiq::Queue.new('high')
		if queue.size == 0 #|| (Sidekiq::Status::complete? job_id == true)
			flash[:success] = "Data imported successfully!"
		elsif queue.size >  0 #|| (Sidekiq::Status::complete? job_id == false)
			flash[:notice] = "Almost done..."
		end
	end

end
