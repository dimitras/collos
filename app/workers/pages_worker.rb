class PagesWorker
	include Sidekiq::Worker
	include Sidekiq::Status::Worker
	#include Sidekiq::Stats

	sidekiq_options queue: "high"
	
	def perform(upfile)
		system "rake db:import_data UPFILE=#{upfile} --trace >> #{upfile}.log &"

		total 100
		at 5, "Almost done"
		#store vino: 'veritas'

		#vino = retrieve :vino
	end

end
