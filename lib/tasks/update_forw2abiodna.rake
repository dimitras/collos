namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:update_forw2abiodna --trace
	desc "update forw2abiodna"
	task :update_forw2abiodna  => :environment do

		samples_file = "workspace/rakeupdates/update_forw2abiodna.csv"
		CSV.foreach(samples_file) do |row|
			barcode = row[2]
			samplename = row[1]
			boxname = row[5]
			newsamplename = row[9]
			newboxname = row[10]
			newfreezername = "GAF#21"
			
			sample = Sample.find_by_barcode_string(barcode)
		
		    newbox = Container.find_by_name(newboxname)
		    if !newbox
		        puts "Create box #{newboxname}"
			    newbox = Container.create(:name => newboxname, :barcode => Barcode.generate(), :container_type => ContainerType.find_by_name("tube rack box"), :retired => false, :parent => Container.find_by_name(newfreezername))
			end

			if sample
				container = Container.find_by_id(sample.container_id)
				if container
					puts "UPDATE CONTAINERs #{container.name} in  #{container.parent.name} #{newbox.inspect}"
					newcontainer = Container.update(sample.container_id, {:name => "#{newsamplename}_container" , :parent => newbox})
				end
				puts "UPDATE SAMPLE #{sample.name} to #{newsamplename}"
				newsample = Sample.update(sample.id, {:name => newsamplename})
			end
		end
	end
end
