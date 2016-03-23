require 'fileutils'

class PagesController < ApplicationController
    skip_before_filter :require_login
    skip_authorization_check

    #include Sidekiq::Status::Worker

    caches_page :index,:help,:about,:contact
    def index; end
    def help; end
    def about; end
    def contact; end

	def upload 
		uploaded_io = params[:file]
		redirect_to(root_url)
		if uploaded_io
			fname = uploaded_io.original_filename
			pname = "#{Rails.root}/workspace/uploads/#{fname}"
			File.open(Rails.root.join('workspace', 'uploads', fname), 'wb') do |file|
				if fname.downcase.end_with?('.xlsx','.xls')
					file.write(uploaded_io.read)
					job_id = PagesWorker.perform_async(pname)
					flash[:notice] = "#{job_id} is being processed..."
					#system "rake db:import_data UPFILE=#{Rails.root}/workspace/uploads/#{uploaded_io.original_filename} --trace >> #{Rails.root}/workspace/uploads/#{uploaded_io.original_filename}.log &"
				else
					flash[:alert] = "Inappropriate format (#{fname}). Use .xlsx, .xls formats."
				end
			end
		else
			flash[:notice] = "Choose your data file first."
		end
	end

	def finished
		job_id = params[:job_id]
		timestamp = Time.now.strftime("%Y-%m-%d")
		investigation = Investigation.order("updated_at").last
		queue = Sidekiq::Queue.new('high')
		if queue.size > 0 
			redirect_to(root_url, :notice => "#{job_id} is queued.")
		elsif investigation.updated_at.to_s.include? timestamp
			if investigation.imported == true
				redirect_to(root_url, :notice => "#{job_id} is completed.") #{investigation.updated_at_changed?} - #{investigation.imported}")
			elsif investigation.imported.nil?
				redirect_to(root_url, :notice => "#{job_id} is almost done...") #{investigation.updated_at_changed?} - #{investigation.imported}")
			end
		elsif !investigation.created_at.to_s.include? timestamp
			Investigation.update(investigation.id, {:imported => nil})
			redirect_to(root_url, :notice => "#{job_id} is almost done..") #{investigation.updated_at_changed?} - #{investigation.imported}")
		else
			redirect_to(root_url, :notice => "#{job_id} is almost done.")
		end
	end

end
