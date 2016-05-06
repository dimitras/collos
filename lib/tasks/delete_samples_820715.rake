namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:delete_samples --trace
	desc "delete samples"
	task :delete_samples  => :environment do
		samples_file = "workspace/data/KT_820715/50_delete_samples.csv"
		source_name = "50"
		
		CSV.foreach(samples_file) do |row|
			sample = Sample.find_by_name(row[0])
			tube = Container.find_by_name("#{row[0]}_container")
			if tube
				p tube.name
				#tube.destroy
			end
			if sample
				if sample.source_name == source_name
					p sample.name
					#sample.destroy
				end
			end
		end
	end
end
