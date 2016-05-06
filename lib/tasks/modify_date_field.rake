namespace :db do
	require 'rubygems'
    require 'csv'

	# USAGE: rake db:modify_date_305413 --trace
	desc "Modify date on timepoint for the second subject of ER samples"
	task :modify_date_305413  => :environment do
		source = "305413"
		old_date = "23Oct15"
		samples_file = "workspace/data/Emanuela_samples/samples.csv"
        CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
			if row[2] == source
				sample_name = row[0]
				collection_time = row[8]
				sample = Sample.find_by_name(sample_name)
				if (sample.time_point.include? old_date) && (sample.source_name == source)
					puts Sample.update(sample.id, {:time_point => collection_time})
					#sample_update = Sample.update(sample.id, {:time_point => collection_time})
				end
			end
		end
	end
end
