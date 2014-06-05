namespace :db do
	
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:load_human_spreadsheet --trace
	desc "import human spreadsheet"
	task :load_human_spreadsheet  => :environment do
		# isatab_directory = "workspace/data/TG_Pentacon39/"
		isatab_directory = "workspace/data/ER_hasmc_trial/"
		investigations = {}
		investigation_file = "#{isatab_directory}investigation.csv"
		CSV.foreach(investigation_file, {:headers=>:first_row}) do |row|
			investigation_identifier = row[0]
			investigation_title = row[1]
			investigation_description = row[2]

			puts "#INVESTIGATIONS \n#{investigation_identifier} | #{investigation_title} | #{investigation_description} \n "
			investigation = Investigation.create(
				:title => investigation_title, 
				:identifier => investigation_identifier, 
				:description => investigation_description
			)
			investigations[investigation_identifier] = investigation
		end
		
		studies = {}
		studies_file = "#{isatab_directory}studies.csv"
		CSV.foreach(studies_file, {:headers=>:first_row}) do |row|
			study_identifier = row[0]
			study_title = row[1]
			study_description = row[2]
			investigation_identifier = row[3]

			puts "#STUDIES \n#{study_title} | #{study_identifier} | #{study_description} | #{investigation_identifier} \n "
			study = Study.create(
				:title         => study_title,
				:identifier    => study_identifier,
				:description   => study_description,
				:investigation => investigations[investigation_identifier]
			)
			studies[study_identifier] = study
		end
		
		# TODO: connect to user_id
		container_laboratory = nil
		contacts_file = "#{isatab_directory}contacts.csv"
		CSV.foreach(contacts_file, {:headers=>:first_row}) do |row|
			identifier = row[0]
			firstname = row[1]
			lastname = row[2]
			role = row[3]
			laboratory = row[4]
			institution = row[5]
			(line_1, line_2, line_3, city, province, state, zip, country) = row[6].split("|")
			email = row[7]
			phone = row[8]
			study_identifier = row[9]

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
			if !row[20].nil?
				(container_tube_type, container_tube_dimensions) = row[20].split('|')
				(tube_container_x, tube_container_y) = container_tube_dimensions.split('x') if container_tube_dimensions
			end
			box_external_identifier = row[21]
			box_label = row[22]
			if !row[23].nil?
				(box_type, box_type_dimensions) = row[23].split('|')
				(box_container_x, box_container_y) = box_type_dimensions.split('x')
			end
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
			
			# collOS says whether a sample is supposed to be entered in the db or not
			if collOS == "yes"
				taxon = Taxon.find_by_scientific_name(organism)
				if !taxon
					puts "#TAXON\n#{organism}\n "
					# taxon = Taxon.create(:scientific_name => organism)
				end
				
				# if the containers are not defined, the sample has been splitted or retired, either way it is labeled as retired and the containers cannot get created
				if freezer_type.nil? && box_type.nil? && container_tube_type.nil? && parent.nil?
					puts "SAMPLE-NO-CONTAINER\n#{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_type} | #{organism} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_type_dimensions} | #{box_label} | #{container_tube_type} | #{container_tube_dimensions} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier} | #{sex} | #{protocols} | #{tags} | #{notes} | #{ethnicity} | #{race} | #{treatments}\n "

					sample = Sample.create(
						:name          => sample_name,
						:barcode       => Barcode.generate(),
						:taxon         => taxon,
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

				container_freezer = Container.find_by_name(freezer_label)
				if !container_freezer
					container_type = ContainerType.find_by_name(freezer_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("freezer")
						puts "#FREEZER TERM\n#{freezer_type} | #{ontology_term}\n "
						container_type = ContainerType.create(
							:name              => freezer_type, 
							:type              => ontology_term, 
							:can_have_children => true, 
							:retired           => false, 
							:shipable          => false
						)
					end
					puts "#FREEZER\n#{freezer_label} | #{container_type}\n "
					container_freezer = Container.create(
						:name           => freezer_label, 
						:barcode        => Barcode.generate(), 
						:container_type => container_type, 
						:retired        => false, 
						:parent         => container_laboratory, 
						:shipped        => false
					)
				end
				
				container_box = Container.find_by_name(box_label)
				if !container_box
					container_type = ContainerType.find_by_name(box_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("box")
						puts "#BOX TERM\n#{box_type} | #{ontology_term}\n "
						container_type = ContainerType.create(
							:name              => box_type, 
							:type              => ontology_term, 
							:can_have_children => true, 
							:retired           => false, 
							:shipable          => true, 
							:x_dimension       => box_container_x, 
							:y_dimension       => box_container_y
						)
					end
					puts "#BOX\n#{box_label} | #{container_type} | #{container_freezer}\n "
					container_box = Container.create(
						:name                => box_label, 
						:barcode             => Barcode.generate(), 
						:container_type      => container_type, 
						:retired             => false, 
						:parent              => container_freezer, 
						:container_x         => box_container_x, 
						:container_y         => box_container_y, 
						:external_identifier => box_external_identifier
					)
				end
				
				container_type = ContainerType.find_by_name(container_tube_type)
				if !container_type
					ontology_term = OntologyTerm.find_by_name("test tube")
					puts "#TUBE TERM\n#{container_tube_type} | #{ontology_term}\n "
					container_type = ContainerType.create(
						:name              => container_tube_type, 
						:type              => ontology_term, 
						:can_have_children => false, 
						:retired           => false, 
						:shipable          => true, 
						:x_dimension       => tube_container_x, 
						:y_dimension       => tube_container_y
					)
				end
				puts "#TUBE\n#{sample_name}_container | #{container_type} | #{container_box} | #{shipped}\n "
				container_tube = Container.create(
					:name           => sample_name + "_container", 
					:barcode        => Barcode.generate(), 
					:container_type => container_type, 
					:retired        => false, 
					:parent         => container_box, 
					:shipped        => shipped, 
					:container_x    => tube_container_x, 
					:container_y    => tube_container_y
				)
				
				puts "#SAMPLES\n#{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_type} | #{organism} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_container_x} | #{box_container_y} | #{box_label} | #{container_tube_type} | #{tube_container_x} | #{tube_container_y} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier} | #{sex} | #{protocols} | #{tags} | #{notes} | #{ethnicity} | #{race} | #{treatments}\n "
				sample = Sample.create(
					:name				 => sample_name, 
					:barcode			 => Barcode.generate(), 
					:taxon_id			 => taxon.id,  
					:container_id		 => container_tube.id, 
					:parent				 => Sample.find_by_name(parent), 
					:sex				 => OntologyTerm.find_by_name(sex), 
					:source_name		 => source_name, 
					:container_x		 => tube_container_x, 
					:container_y		 => tube_container_y, 
					:external_identifier => sample_external_identifier, 
					:age 				 => age, 
					:timeunit 			 => OntologyTerm.find_by_name(age_unit), 
					:ethnicity           => OntologyTerm.find_by_name(ethnicity),
					:race				 => OntologyTerm.find_by_name(race), 
					:genotype 			 => genotype, 
					:time_point			 => collection_time, 
					:treatments			 => treatments, 
					:replicate			 => replicate, 
					:tissue_type  		 => OntologyTerm.find_by_name(tissue_type),
					:primary_cell 		 => OntologyTerm.find_by_name(primary_cell),
					:material_type		 => OntologyTerm.find_by_name(material_type),
					:protocols           => protocols,
					:notes               => notes,
					:tags                => tags
				)
				sample.studies << studies[study_identifier]

			end
		end
	end

end
