namespace :db do
	
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:load_katie_spreadsheet --trace
	desc "import katie spreadsheet"
	task :load_katie_spreadsheet  => :environment do
		isatab_directory = "workspace/data/Katie_samples/"
		investigations = {}
		investigation_file = "#{isatab_directory}investigation.csv"
		CSV.foreach(investigation_file, {:headers=>:first_row}) do |row|
			investigation_identifier = row[0]
			investigation_title = row[1]
			investigation_description = row[2]
			if !Investigation.exists?(identifier: investigation_identifier)
				puts "#INVESTIGATIONS \n#{investigation_identifier} | #{investigation_title} | #{investigation_description} \n "
				investigation = Investigation.create(
					:title => investigation_title, 
					:identifier => investigation_identifier, 
					:description => investigation_description
				)
				investigations[investigation_identifier] = investigation
			else
				puts "NOTICE: #{investigation_identifier} exists in the database. Samples will be added to the existing investigation."
				investigations[investigation_identifier] = Investigation.find_by_identifier(investigation_identifier)
			end
		end
	
		studies = {}
		studies_file = "#{isatab_directory}studies.csv"
		CSV.foreach(studies_file, {:headers=>:first_row}) do |row|
			study_identifier = row[0]
			study_title = row[1]
			study_description = row[2]
			investigation_identifier = row[3]
			if !Study.exists?(identifier: study_identifier)
				puts "#STUDIES \n#{study_title} | #{study_identifier} | #{study_description} | #{investigation_identifier} \n "
				study = Study.create(
					:title         => study_title,
					:identifier    => study_identifier,
					:description   => study_description,
					:investigation => investigations[investigation_identifier]
				)
				studies[study_identifier] = study
			else
				puts "NOTICE: #{study_identifier} exists in the database. Samples will be added to the existing study."
				studies[study_identifier] = Study.find_by_identifier(study_identifier)
			end
		end
		
		# TODO: connect to user_id
		container_laboratory = nil
		contacts_file = "#{isatab_directory}contacts.csv"
		investigators = {}
		CSV.foreach(contacts_file, {:headers=>:first_row}) do |row|
			identifier = row[0]
			firstname = row[1]
			lastname = row[2]
			role = row[3]
			laboratory = row[4]
			institution = row[5]
			if row[6]
				(line_1, line_2, line_3, city, province, state, zip, country) = row[6].split("|")
			end
			email = row[7]
			phone = row[8]
			study_identifier = row[9]

			if !Person.exists?(identifier: identifier)
				puts "#INVESTIGATORS\n#{identifier} | #{firstname} | #{lastname} | #{role} | #{phone} | #{email} | #{institution} | #{study_identifier}\n "
				# TODO: :type => role, > rename type
				person = Person.create(
					:identifier  => identifier,
					:firstname   => firstname,
					:lastname    => lastname,
					:email       => email,
					:phone       => phone,
					:laboratory  => laboratory,
					:institution => institution
				)
				person.studies << studies[study_identifier]
				container_institution = Container.find_by_name(institution)
				if !container_institution
					container_type = ContainerType.find_by_name("University")

					puts "#UNIVERSITY \n#{institution} | #{container_type}\n "
					container_institution = Container.create(
						:name           => institution, 
						:barcode        => Barcode.generate(), 
						:container_type => container_type, 
						:retired        => false, 
						:shipped        => false
					)
				end

				if !laboratory.nil?
					container_laboratory = Container.find_by_name(laboratory)
					if !container_laboratory
						container_type = ContainerType.find_by_name("Laboratory")
	
						puts "#LAB \n#{laboratory} | #{container_type}\n "
						container_laboratory = Container.create(
							:name           => laboratory, 
							:barcode        => Barcode.generate(), 
							:container_type => container_type, 
							:retired        => false, 
							:parent         => container_institution, 
							:shipped        => false
						)
					end
				end

				if !line_1.nil?
					address_line1 = Address.find_by_line_1(line_1)
					if !address_line1
						puts "#ADDRESS\n#{line_1} | #{city}\n "
						new_address = Address.create(
							:city     => city, 
							:country  => country, 
							:line_1   => line_1, 
							:line_2   => line_2, 
							:line_3   => line_3, 
							:province => province, 
							:state    => state, 
							:zip      => zip
						)
					end
				end
			else
				puts "NOTICE: #{identifier} exists in the database."
				investigators[identifier] = Person.find_by_identifier(identifier)
				if !investigators[identifier].studies.include?(studies[study_identifier]) 
					investigators[identifier].studies << studies[study_identifier]
					puts "#{identifier} is now connected to #{study_identifier}."
				end
			end
		end
	
		# TODO: fix parent for sample, if the samples.csv is not sorted, the parents are not assigned
		samples_file = "#{isatab_directory}samples.csv"
		CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
			identifier = row[0]
			sample_name = row[0]
			parent = row[1]
			source_name = row[2]
			organism = row[3]
			ethnicity = row[4]
			race = row[5]
			genotype = row[6]
			sex = row[7]
			collection_time = row[8]
			treatments = row[9]
			replicate = row[10]
			tissue_type = row[11]
			primary_cell = row[12]
			material_type = row[13]
			age = row[14]
			age_unit = row[15]
			protocols = row[16]
			notes = row[17]
			tags = row[18]
			sample_external_identifier = row[19]
			container_tube_type = row[20]
			box_external_identifier = row[21]
			box_label = row[22]
			box_type = row[23]
			freezer_label = row[24]
			freezer_type = row[25]
			shipped = false
			if row[26] == "yes"
				shipped = true
			end
			shipper = row[27]
			receiver = row[28]
			collOS = row[29]
			study_identifier = row[30]
			
			# go to the next sample if this one exists in the database			
			if Sample.exists?(name: sample_name)
				puts "NOTICE: #{sample_name} exists in the database."
				next
			end

			# collOS field  says whether a sample is supposed to be entered in the db or not
			if collOS == "yes"
				taxon = Taxon.find_by_scientific_name(organism)
				if !taxon
					puts "#NEW TAXON\n#{organism}\n "
					taxon = Taxon.create(:scientific_name => organism)
				end
				
				# if the containers are not defined, the sample has been splitted or retired, either way it is labeled as retired and the containers cannot get created
				if freezer_type.nil? && box_type.nil? && container_tube_type.nil? && parent.nil?
					puts "SAMPLE-NO-CONTAINER\n#{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_type} | #{organism} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_label} | #{container_tube_type} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier} | #{sex} | #{protocols} | #{tags} | #{notes} | #{ethnicity} | #{race} | #{treatments}\n "
					sample = Sample.create(
						:name          => sample_name,
						:barcode       => Barcode.generate(),
						:taxon         => taxon.id,
						:retired       => true,
						:age           => age,
						:source_name   => source_name,
						:sex           => OntologyTerm.find_by_name(sex),
						:timeunit      => OntologyTerm.find_by_name(age_unit),
						:ethnicity     => OntologyTerm.find_by_name(ethnicity),
						:race          => OntologyTerm.find_by_name(race),
						:genotype      => genotype,
						:time_point    => collection_time,
						:treatments    => treatments,
						:replicate     => replicate,
						:tissue_type   => OntologyTerm.find_by_name(tissue_type),
						:primary_cell  => OntologyTerm.find_by_name(primary_cell),
						:material_type => OntologyTerm.find_by_name(material_type),
						:protocols     => protocols,
						:notes         => notes,
						:tags          => tags
					)
					sample.studies << studies[study_identifier]
					next
				end
				
				# create the freezer container
				container_freezer = Container.find_by_name(freezer_label)
				if !container_freezer
					container_type = ContainerType.find_by_name(freezer_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("freezer")
						puts "#FREEZER TERM\n#{freezer_type} | #{ontology_term.name}\n "
						container_type = ContainerType.create(
							:name              => freezer_type,
							:type              => ontology_term,
							:can_have_children => true,
							:retired           => false,
							:shipable          => false
						)
					end
					puts "#FREEZER\n#{freezer_label} | #{container_type.name}\n "
					container_freezer = Container.create(
						:name           => freezer_label, 
						:barcode        => Barcode.generate(), 
						:container_type => container_type, 
						:retired        => false, 
						:parent         => container_laboratory, 
						:shipped        => false
					)
				end
			
				# create the box container	
				container_box = Container.find_by_name(box_label)
				if !container_box
					container_type = ContainerType.find_by_name(box_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("box")
						puts "#BOX TERM\n#{box_type} | #{ontology_term.name}\n "
						container_type = ContainerType.create(
							:name              => box_type, 
							:type              => ontology_term, 
							:can_have_children => true, 
							:retired           => false, 
							:shipable          => true 
						)
					end
					puts "#BOX\n#{box_label} | #{container_type.name} | #{container_freezer.name}\n "
					container_box = Container.create(
						:name                => box_label, 
						:barcode             => Barcode.generate(), 
						:container_type      => container_type, 
						:retired             => false, 
						:parent              => container_freezer, 
						:external_identifier => box_external_identifier
					)
				end
			
				# create the tube container	
				container_type = ContainerType.find_by_name(container_tube_type)
				if !container_type
					ontology_term = OntologyTerm.find_by_name("test tube")
					puts "#TUBE TERM\n#{container_tube_type} | #{ontology_term.name}\n "
					container_type = ContainerType.create(
						:name              => container_tube_type, 
						:type              => ontology_term, 
						:can_have_children => false, 
						:retired           => false, 
						:shipable          => true
					)
				end
				puts "#TUBE\n#{sample_name}_container | #{container_type.name} | #{container_box.name} | #{shipped}\n "
				container_tube = Container.create(
					:name           => sample_name + "_container", 
					:barcode        => Barcode.generate(), 
					:container_type => container_type, 
					:retired        => false, 
					:parent         => container_box, 
					:shipped        => shipped
				)
				# create samples	
				puts "#SAMPLE\n#{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_type} | #{organism} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_label} | #{container_tube_type}  | #{shipped} | #{receiver} | #{collOS} | #{study_identifier} | #{sex} | #{protocols} | #{tags} | #{notes} | #{ethnicity} | #{race} | #{treatments}\n "
				sample = Sample.create(
					:name				=> sample_name, 
					:barcode			=> Barcode.generate(), 
					:taxon_id			=> taxon.id,  
					:container_id		 	=> container_tube.id, 
					:parent				=> Sample.find_by_name(parent), 
					:sex				=> OntologyTerm.find_by_name(sex), 
					:source_name		 	=> source_name, 
					:external_identifier 		=> sample_external_identifier, 
					:age 				=> age, 
					:timeunit 			=> OntologyTerm.find_by_name(age_unit), 
					:ethnicity           		=> OntologyTerm.find_by_name(ethnicity),
					:race				=> OntologyTerm.find_by_name(race), 
					:genotype 			=> genotype, 
					:time_point			=> collection_time, 
					:treatments			=> treatments, 
					:replicate			=> replicate, 
					:tissue_type  		 	=> OntologyTerm.find_by_name(tissue_type),
					:primary_cell 		 	=> OntologyTerm.find_by_name(primary_cell),
					:material_type		 	=> OntologyTerm.find_by_name(material_type),
					:protocols           		=> protocols,
					:notes               		=> notes,
					:tags               		=> tags
				)
				sample.studies << studies[study_identifier]
			end
		end
		puts Sample.count
	end
end
