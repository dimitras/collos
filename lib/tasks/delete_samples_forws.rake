namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:deleteforwsamples --trace
	desc "delete samples"
	task :deleteforwsamples  => :environment do
		samples_file = "workspace/data/CS_FORW/FORWs_non-existing.csv"
		
		CSV.foreach(samples_file) do |row|
			sample = Sample.find_by_id(row[0])
			cont_id = sample.container_id
			tube = Container.find_by_id(cont_id)
			if tube
				p "#{tube.name}       #{tube.retired}"
				#tube.destroy
			end
			if sample
				p "#{sample.name}       #{sample.retired}"
				#sample.destroy
			end
		end
	end
end
