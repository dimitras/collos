namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:update_samples --trace
	desc "update samples"
	task :update_samples  => :environment do

		samples_file = "workspace/data/CS_FORW/updated_samples.csv"
		CSV.foreach(samples_file) do |row|
			name = row[0]
			aliquot = row[1]
			box_label = row[2]
			retired = row[3]

			sample = Sample.find_by_name(name)
			
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

				container = Container.find_by_id(sample.container_id)
				if container
					p "UPDATE CONTAINER #{container.parent.name} #{box.inspect}"
					update_container = Container.update(sample.container_id, {:parent => box})
				end
				if sample
					puts "UPDATE SAMPLE #{sample.name}"
					sample_update = Sample.update(sample.id, {:replicate => aliquot})
				end
			end
		end
	end
end
