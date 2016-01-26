namespace :db do
	require 'rubygems'
    require 'csv'

	# USAGE: rake db:modify_tissues --trace
	desc "Modify tissues of ER samples"
	task :modify_tissues  => :environment do
		type1 = "brain"
		type1_mod = "skeletal muscle"
		type2 = "cecum cancer cell line"
		type2_mod = "cecum content"
		tissue1 = OntologyTerm.find_by_name(type1)
		tissue2 = OntologyTerm.find_by_name(type2)
		tissue1_mod = OntologyTerm.find_by_name(type1_mod)
		tissue2_mod = OntologyTerm.find_by_name(type2_mod)
	
		samples_file = "workspace/data/ER_804319/samples.csv"
        CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
			sample_name = row[0]
			old_sample_name = row[1]
			sample_type = row[13]
			sample = Sample.find_by_name(old_sample_name)
			tissue = OntologyTerm.find_by_name(sample_type)

			if sample.tissue_type_name == type1
				puts "#{sample.id} #{sample.name} => #{sample_name} ,  #{sample.tissue_type_name} => #{tissue1_mod.name}"
				sample_update = Sample.update(sample.id, {:name => sample_name, :tissue_type => tissue1_mod})
			elsif old_sample_name.include? type2
				puts "#{sample.id} #{sample.name} => #{sample_name}"
				sample_update = Sample.update(sample.id, {:name => sample_name})
			else
				next
			end
		end
	end
end
