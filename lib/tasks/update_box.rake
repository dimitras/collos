namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:update_ivsa_box --trace
	desc "update box in ivsa"
	task :update_ivsa_box  => :environment do

        box = Container.find_by_barcode_string("PC7A77C")
        puts box.name

		samples_file = "workspace/rakeupdates/2016IVSA_samples__.csv"
		CSV.foreach(samples_file) do |row|	
            barcode = row[2]
			sample = Sample.find_by_barcode_string(barcode)

			if sample
			    puts sample.name
			    tube = Container.find_by_id(sample.container_id)
			    if tube
			        puts "#{tube.name} from #{tube.parent.name} to #{box.name}"
			        Container.update(tube.id, {:parent => box})
			    end
			end
		end
	end
end
