namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:load_additional_data --trace
	desc "import additional human data for already entered TG samples"
	task :load_additional_data  => :environment do
		races = { 
				"White" => 1,
   				"Asian" => 2,
				"Black or African American" => 3,
				"Native Hawaiian or Other Pacific Islander" => 4,
				"American Indian or Alaska Native" => 5
    			}
    	ethnicities = {
					  "Hispanic or Latino" => 3,
					  "Not Hispanic or Latino" => 4
					  }

		samples_file = "workspace/data/TG_Pentacon39/samples.csv"
		CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
			name = row[0]

			ethnicity = row[4]
			if ethnicities.has_key?(ethnicity)
        		ethnicity_id = ethnicities[ethnicity].to_i
        	end

			race = row[5]
        	if races.has_key?(race)
        		race_id = races[race].to_i
        	end

			if row[19]
				external_identifier = row[19]
			end

			sample = Sample.find_by_name(name)
			if sample
				puts "#{sample.id} #{sample.name} #{race} #{race_id} #{ethnicity} #{ethnicity_id} EXTID #{external_identifier}"
				# sample_update = Sample.update(sample.id, { :ethnicity_id => ethnicity_id, :race_id => race_id, :external_identifier => external_identifier})
			end
		end
	end

	# USAGE: rake db:load_additional_data_er --trace
	desc "import additional human data for already entered ER samples"
	task :load_additional_data_er  => :environment do
		races = { 
				"White" => 1,
   				"Asian" => 2,
				"Black or African American" => 3,
				"Native Hawaiian or Other Pacific Islander" => 4,
				"American Indian or Alaska Native" => 5
    			}

		samples_file = "workspace/data/ER_hasmc_trial/samples.csv"
		CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
			name = row[0]
			race = row[5]
			if races.has_key?(race)
        		race_id = races[race].to_i
        	end
			tissue_type = row[11]
			material_type = row[13]
			age = row[14]
			age_unit = row[15]

			sample = Sample.find_by_name(name)
			if sample
				puts "#{sample.id} #{sample.name} #{race} #{race_id} #{tissue_type} #{material_type} #{age} #{age_unit}"
				# sample_update = Sample.update(sample.id, { :tissue_type => OntologyTerm.find_by_name(tissue_type), :material_type => OntologyTerm.find_by_name(material_type), :race_id => race_id, :age => age, :timeunit => OntologyTerm.find_by_name(age_unit) })
			end
		end
	end
end
