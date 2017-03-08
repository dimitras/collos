namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:update_ivsa --trace
	desc "update material type in ivsa"
	task :update_ivsa  => :environment do

		samples_file = "workspace/rakeupdates/update_ivsa.csv"
		CSV.foreach(samples_file) do |row|
			barcode = row[2]
			
			sample = Sample.find_by_barcode_string(barcode)
		
			if sample
                material = OntologyTerm.find_by_name("CmRNA")    
				Sample.update(sample.id, {:material_type => material})
			end
		end
	end
end
