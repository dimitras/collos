namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:update_forw2a --trace
	desc "update aliquot1 forw2a samples"
	task :update_forw2a  => :environment do

		samples_file = "workspace/data/CS_FORW2a/updated_samples.csv"
		CSV.foreach(samples_file) do |row|
			barcode = row[0]
			name = row[1]
			aliquot = row[2]
			quantity = row[3]
			box_label = row[4]
			retired = row[5]

			sample = Sample.find_by_barcode_string(barcode)
			
			if retired == "TRUE"
				if sample
					puts "RETIRED #{sample.name}"
					sample_update = Sample.update(sample.id, {:retired => retired})
				end
			else
				box = Container.find_by_name(box_label)
				if !box
					p "NEW BOX #{box_label}"
					box = Container.create(:name => box_label,	:barcode => Barcode.generate(), :container_type => ContainerType.find_by_name("tube rack box"), :retired => false, :parent => Container.find_by_name("GAF#20"))
				end

				if sample
					container = Container.find_by_id(sample.container_id)
					if container
						p "UPDATE CONTAINER #{container.parent.name} #{box.inspect}"
						update_container = Container.update(sample.container_id, {:parent => box})
					end
					puts "UPDATE SAMPLE #{sample.name} #{quantity}"
					sample_update = Sample.update(sample.id, {:quantity => quantity, :replicate => aliquot})
				end
			end
		end
	end
end
