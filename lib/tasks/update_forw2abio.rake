namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:update_forw2abio --trace
	desc "update forw2abio"
	task :update_forw2abio  => :environment do

		samples_file = "workspace/rakeupdates/update_forw2abio.csv"
		CSV.foreach(samples_file) do |row|
			barcode = row[1]
			samplename = row[0]
			boxname = row[2]
			newboxname = row[4]
			
			sample = Sample.find_by_barcode_string(barcode)
		
		    newbox = Container.find_by_name(newboxname)

			if sample
				container = Container.find_by_id(sample.container_id)
				if container
					puts "Move #{container.name} in #{container.parent.name} to #{newbox.name}"
					newcontainer = Container.update(sample.container_id, {:parent => newbox})
				end
			end
		end
	end
end
