namespace :db do	
	require 'rubygems'
	require 'csv'
	require 'roo'

	
	# USAGE: rake db:import_data --trace
	desc "import spreadsheet"
	task :import_data  => :environment do
		start = Time.now
		p "########################################"
		p "### Data import starting... #{start.strftime("%d/%m/%Y %H:%M")} ###"
		# split xlsx input file to separate csvs
		#ifile = "workspace/data/KT_820715/820715.xlsx"
		ifile = ENV["UPFILE"]
		p "File: #{ifile}"
		fname = ifile.split(".")[0]
		xlsx = Roo::Spreadsheet.open(ifile)
		Dir.mkdir("#{fname}") unless File.exists?("#{fname}")

		xlsx.sheets.each do |sheet|
			if sheet !~ /(Settings|CV|Restrictions)/
				p sheet
				xlsx.default_sheet = sheet
				xlsx.to_csv("#{fname}/#{sheet}.csv")
			end
		end
		p "Timestamp >> #{(Time.now - start).to_i}"
		p "#########################################"
		
		isatab_directory = fname
		#isatab_directory = "workspace/data/KT_820715"
		investigation = nil
		investigations = {}
		investigation_file = "#{isatab_directory}/investigation.csv"
		CSV.foreach(investigation_file, {:headers=>:first_row}) do |row|
			investigation_identifier = row[0]
			investigation_title = row[1]
			investigation_description = row[2]
			if !Investigation.exists?(identifier: investigation_identifier)
				investigation = Investigation.create(
					:title => investigation_title, 
					:identifier => investigation_identifier, 
					:description => investigation_description
				)
				investigations[investigation_identifier] = investigation
				puts "#NEW INVESTIGATION #{investigation.inspect} added"
			else
				puts "NOTICE: #{investigation_identifier} exists in the database. Samples will be added to the existing investigation."
				investigation = Investigation.find_by_identifier(investigation_identifier)
				investigation_update = Investigation.update(investigation.id, {:imported => nil})
				investigations[investigation_identifier] = Investigation.find_by_identifier(investigation_identifier)
			end
		end
	
		studies = {}
		studies_file = "#{isatab_directory}/studies.csv"
		CSV.foreach(studies_file, {:headers=>:first_row}) do |row|
			study_identifier = row[0]
			study_title = row[1]
			study_description = row[2]
			investigation_identifier = row[3]
			if !Study.exists?(identifier: study_identifier)
				study = Study.create(
					:title         => study_title,
					:identifier    => study_identifier,
					:description   => study_description,
					:investigation => investigations[investigation_identifier]
				)
				studies[study_identifier] = study
				puts "#NEW STUDY #{study.inspect} added"
			else
				puts "NOTICE: #{study_identifier} exists in the database. Samples will be added to the existing study."
				studies[study_identifier] = Study.find_by_identifier(study_identifier)
				p "#{studies[study_identifier].identifier} is the study identifier that is stored."
			end
		end
		
		# TODO: connect to user_id
		container_laboratory = nil
		contacts_file = "#{isatab_directory}/investigators.csv"
		investigators = {}
		store_laboratory = ""
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
			store_container = row[10]
				
			if !Person.exists?(identifier: identifier)

				container_institution = Container.find_by_name(institution)
				puts "#UNIVERSITY #{container_institution.name} found in the db" if container_institution
				if !container_institution
					container_type = ContainerType.find_by_name("University")
					container_institution = Container.create(
						:name           => institution, 
						:barcode        => Barcode.generate(), 
						:container_type => container_type, 
						:retired        => false, 
						:shipped        => false
					)
					puts "#NEW UNIVERSITY #{container_institution.inspect}\n"
				end
					
				if !laboratory.nil?
					container_laboratory = Container.find_by_name(laboratory)
					puts "#LABORATORY #{container_laboratory.name} found in the db" if container_laboratory
					if !container_laboratory
						container_type = ContainerType.find_by_name("Laboratory")
	
						container_laboratory = Container.create(
							:name           => laboratory, 
							:barcode        => Barcode.generate(), 
							:container_type => container_type, 
							:retired        => false, 
							:parent         => container_institution, 
							:shipped        => false
						)
						puts "#NEW LAB #{container_laboratory.inspect} added\n"
					end
					if store_container.to_i == 1
						store_laboratory = container_laboratory
						p "#STORE LABORATORY is #{store_laboratory.name}."
					end			
				end

				# TODO: :type => role, > rename type
				person = Person.create(
										:identifier   => identifier,
                                        :firstname    => firstname,
                                        :lastname     => lastname,
                                        :email        => email,
                                        :phone        => phone,
                                        :container_id => container_laboratory.id,
										:laboratory   => container_laboratory.name,
                                        :institution  => container_laboratory.parent.name
				)
				puts "#NEW INVESTIGATOR #{person.inspect} added at study #{study_identifier}\n "
				person.studies << studies[study_identifier]

				if !line_1.nil?
					address_line1 = Address.find_by_line_1(line_1)
					if !address_line1
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
						puts "#NEW ADDRESS #{new_address.inspect} added\n"
					end
				end
			else
				puts "NOTICE: #{identifier} exists in the database."
				investigators[identifier] = Person.find_by_identifier(identifier)
				if !investigators[identifier].studies.include?(studies[study_identifier]) 
					investigators[identifier].studies << studies[study_identifier]
					puts "#{identifier} is now connected to #{study_identifier}."
				end
				if store_container.to_i == 1
					store_laboratory = Container.find_by_name(laboratory)
					puts "#STORE LABORATORY is (#{Container.find_by_name(laboratory)})"
				end
			end
		end


		# parse ontology terms file
		oterms_file = "#{isatab_directory}/oterms.csv"
		if File.exist?(oterms_file)
		    puts "ERROR: #{oterms_file} file was not found."
		end
		terms_list = Hash.new {|h,k| h[k] = []} 
		CSV.foreach(oterms_file, {:headers=>:first_row}) do |row|
			term_name = row[0]
			term_uri = row[1]
			o_prefix = row[2]
			o_uri = row[3]
			o_name = row[4]
			description = row[5]
			term_acc = term_uri.split("/")[-1]
			terms_list[term_name] = [o_name, term_acc, o_uri, o_prefix]
		end
        p "NOTE: Parsed the oterms."
	
		# TODO: fix parent for sample, if the samples.csv is not sorted, the parents are not assigned
		past_container = ""
		containers_shipped = {}
		samples_file = "#{isatab_directory}/samples.csv"
		CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
			identifier = row[0]
			sample_name = row[0]
			parent = row[1]
			source_name = row[2]
			organism = row[3]
			ethnicity = row[4]
			race = row[5]
			strain = row[6]
			genotype = row[7]
			sex = row[8]
			collection_time = row[9]
			treatments = row[10]
			replicate = row[11]
			tissue_type = row[12]
			primary_cell = row[13]
			material_type = row[14]
			quantity = row[15]
			age = row[16]
			age_unit = row[17]
			protocols = row[18]
			notes = row[19]
			tags = row[20]
			sample_external_identifier = row[21]
			container_tube_type = row[22]
			box_external_identifier = row[23]
			box_label = row[24]
			box_type = row[25]
			freezer_label = row[26]
			freezer_type = row[27]
			shipped = false
			if row[28] == "yes"
				shipped = true
			end
			shipper = row[29]
			receiver = row[30]
			collOS = row[31]
			study_identifier = row[32]

            p sample_name
			# check for field length?
			#puts "# #{treatments} has #{treatments.length} chars"
			#if tissue_type.length > 25 || treatments.length > 25 || material_type.length > 25 || sample_name.length >25 || primary_cell.length > 25 || box_label.length > 25
			#	raise Exception.new("The fields used on the labels shouldn't exceed 25 chars.")
			#end

			# go to the next sample if this one exists in the database			
			if Sample.exists?(name: sample_name)
				puts "NOTICE: #{sample_name} exists in the database."
				next
			end
			
			# collOS field  says whether a sample is supposed to be entered in the db or not
			if collOS == "yes"
			    puts "Sample must be added to the db."
				taxon = Taxon.find_by_scientific_name(organism)
				puts "#TAXON #{taxon.scientific_name} found in the db" if taxon
				if !taxon
					if organism
						taxon = Taxon.create(:scientific_name => organism)
						puts "#TAXON #{taxon.scientific_name} added"
					end
				end
			
				race_identifier = nil
				if race	
					race_nm = Race.find_by_name(race)
					puts "#RACE #{race_nm.name} found in the db" if race_nm
					if !race_nm
                        race_nm = Race.create(:name => race)
						puts "#RACE #{race_nm.inspect} added"
					end
					race_identifier = race_nm.id
				end

				strain_identifier = nil
				if strain
					strain_nm = Strain.find_by_name(strain)
					puts "#STRAIN #{strain_nm.name} found in the db" if strain_nm
					if !strain_nm
						strain_nm = Strain.create(:name => strain)
						puts "#STRAIN #{strain_nm.inspect} added"
					end
					strain_identifier = strain_nm.id
				end

				ethnicity_identifier = nil
				if ethnicity
					ethnicity_nm = Ethnicity.find_by_name(ethnicity)
					ethnicity_identifier = ethnicity_nm.id if ethnicity_nm
					puts "#ETHNICITY #{ethnicity_nm.name} found in the db" if ethnicity_nm
					if !ethnicity_nm 
						ethnicity_nm = Ethnicity.create(:name => ethnicity)
                        ethnicity_identifier = ethnicity_nm.id
						puts "#ETHNICITY #{ethnicity_nm.inspect} added"
					end
				end

				ageunit = OntologyTerm.find_by_name(age_unit)
				puts "#AGE UNIT #{ageunit.name} found in the db" if ageunit
				if !ageunit && age_unit
					if terms_list.has_key?(age_unit)
						ontology = Ontology.find_by_name(terms_list[age_unit][0])
						puts "#ONTOLOGY #{ontology.name} found in the db" if ontology
						if !ontology
							ontology = Ontology.create(:name => terms_list[age_unit][0], :uri => terms_list[age_unit][2], :prefix => terms_list[age_unit][3])
							puts "#NEW ONTOLOGY #{ontology.prefix} added"
						end
						ontology_id = ontology.id
                        term_accession = terms_list[age_unit][1]
                        ageunit = OntologyTerm.create(:name => age_unit, :ancestry => '15', :ontology_id => ontology_id, :accession => term_accession )
						puts "#NEW AGE UNIT #{ageunit.name} added under #{ageunit.parent.name}"
					else
                        puts "WARNING: missing #{age_unit} in ontology terms"
                        break
					end
				end

				bio_sex = OntologyTerm.find_by_name(sex)
				puts "#SEX #{bio_sex.name} found in the db" if bio_sex
				if !bio_sex && sex
					if terms_list.has_key?(sex)
						ontology = Ontology.find_by_name(terms_list[sex][0])
                        puts "#ONTOLOGY #{ontology.name} found in the db" if ontology
                        if !ontology
							ontology = Ontology.create(:name => terms_list[sex][0], :uri => terms_list[sex][2], :prefix => terms_list[sex][3])
                            puts "#NEW ONTOLOGY #{ontology.prefix} added"
                        end
                        ontology_id = Ontology.find_by_name(terms_list[sex][0]).id
                        term_accession = terms_list[sex][1]
                        bio_sex = OntologyTerm.create(:name => sex, :ancestry => '7', :ontology_id => ontology_id, :accession => term_accession)
                        puts "#SEX #{bio_sex.name} added under #{bio_sex.parent.name}"
                    else
						puts "WARNING: missing #{tissue_type} in ontology terms"
                        break
					end
				end
				
				tissue = OntologyTerm.find_by_name(tissue_type)
				puts "#TISSUE #{tissue.name} found in the db" if tissue
				#if !tissue && tissue_type
				if !OntologyTerm.exists?(:name => tissue_type) && tissue_type
                                        #tissue = OntologyTerm.create(:name => tissue_type, :parent => OntologyTerm.find_by_id(22), :ancestry => '22')
					if terms_list.has_key?(tissue_type)
						ontology = Ontology.find_by_name(terms_list[tissue_type][0])
                                                puts "#ONTOLOGY #{ontology.name} found in the db" if ontology
                                                if !ontology
                                                        ontology = Ontology.create(:name => terms_list[tissue_type][0], :uri => terms_list[tissue_type][2], :prefix => terms_list[tissue_type][3])
                                                        puts "#NEW ONTOLOGY #{ontology.prefix} added"
                                                end
						ontology_id = Ontology.find_by_name(terms_list[tissue_type][0]).id
						term_accession = terms_list[tissue_type][1]
						tissue = OntologyTerm.create(:name => tissue_type, :ancestry => '22', :ontology_id => ontology_id, :accession => term_accession)
						puts "#TISSUE #{tissue.name} added under #{tissue.parent.name}"
					else
						puts "WARNING: missing #{tissue_type} in ontology terms"
						break
					end
                                end

				material = OntologyTerm.find_by_name(material_type)
				puts "#MATERIAL TYPE #{material.name} found in the db" if material
				if !material && material_type
                                        if terms_list.has_key?(material_type)
						ontology = Ontology.find_by_name(terms_list[material_type][0])
                                                puts "#ONTOLOGY #{ontology.name} found in the db" if ontology
                                                if !ontology
                                                        ontology = Ontology.create(:name => terms_list[material_type][0], :uri => terms_list[material_type][2], :prefix => terms_list[material_type][3])
                                                        puts "#NEW ONTOLOGY #{ontology.prefix} added"
                                                end
                                                ontology_id = ontology.id
                                                term_accession = terms_list[material_type][1]
                                                material = OntologyTerm.create(:name => material_type, :ancestry => '26', :ontology_id => ontology_id, :accession => term_accession)
                                                puts "#MATERIAL TYPE #{material.name} added under #{material.parent.name}"
                                        elsif
                                                puts "WARNING: missing #{material_type} in ontology terms"
                                                break
                                        end
                                end

				primary = OntologyTerm.find_by_name(primary_cell)
				puts "#PRIMARY CELL #{primary.name} found in the db" if primary
				if !primary && primary_cell
                                        if terms_list.has_key?(primary_cell)
						ontology = Ontology.find_by_name(terms_list[primary_cell][0])
                                                puts "#ONTOLOGY #{ontology.name} found in the db" if ontology
                                                if !ontology
                                                        ontology = Ontology.create(:name => terms_list[primary_cell][0], :uri => terms_list[primary_cell][2], :prefix => terms_list[primary_cell][3])
                                                        puts "#NEW ONTOLOGY #{ontology.prefix} added"
                                                end
                                                ontology_id = Ontology.find_by_name(terms_list[primary_cell][0]).id
                                                term_accession = terms_list[primary_cell][1]
                                                primary = OntologyTerm.create(:name => primary_cell, :ancestry => '41', :ontology_id => ontology_id, :accession => term_accession)
                                                puts "#PRIMARY CELL #{primary.name} added under #{primary.parent.name}"
                                        elsif
                                                puts "WARNING: missing #{primary_cell} in ontology terms"
                                                break
                                        end
                                end


				# if the containers are not defined, the sample has been splitted or retired, either way it is labeled as retired and the containers cannot get created
				if freezer_type.nil? && box_type.nil? && container_tube_type.nil? && parent.nil?
					sample = Sample.create(
						:name          => sample_name,
						:barcode       => Barcode.generate(),
						:taxon         => taxon.id,
						:retired       => true,
						:age           => age,
						:source_name   => source_name,
						:sex           => bio_sex,
						:timeunit      => ageunit,
						:ethnicity_id  => ethnicity_identifier,
						:race_id       => race_identifier,
						:strain_id     => strain_identifier,
						:genotype      => genotype,
						:time_point    => collection_time,
						:treatments    => treatments,
						:replicate     => replicate,
						:tissue_type   => tissue,
						:primary_cell  => primary,
						:material_type => material,
						:quantity      => quantity,
						:protocols     => protocols,
						:notes         => notes,
						:tags          => tags
					)
					sample.studies << studies[study_identifier]
					puts "#NEW SAMPLE NO-CONTAINER #{sample.inspect} added"
					next
				end
				
				# create the freezer container
				container_freezer = Container.find_by_name(freezer_label)
				puts "#FREEZER #{container_freezer.name} found in the db" if container_freezer
				if !container_freezer
					container_type = ContainerType.find_by_name(freezer_type)
					puts "#FREEZER TYPE #{container_type.name} found in the db" if container_type
					if !container_type
						ontology_term = OntologyTerm.find_by_name("freezer")
						container_type = ContainerType.create(
							:name              => freezer_type,
							:type              => ontology_term,
							:can_have_children => true,
							:retired           => false,
							:shipable          => false
						)
						puts "#NEW FREEZER TYPE #{container_type.inspect} added"
					end
					puts "CHECK #STORE LABORATORY is #{store_laboratory.inspect}"
					container_freezer = Container.create(
						:name           => freezer_label, 
						:barcode        => Barcode.generate(), 
						:container_type => container_type, 
						:retired        => false, 
						:parent         => store_laboratory, 
						:shipped        => false
					)
					puts "#NEW FREEZER #{container_freezer.inspect} added"
				end
			
				# create the box container	
				container_box = Container.find_by_name(box_label)
				puts "#BOX #{container_box.name} found in the db" if container_box
				if !container_box
					container_type = ContainerType.find_by_name(box_type)
					puts "#BOX TYPE #{container_type.name} found in the db" if container_type
					if !container_type
						ontology_term = OntologyTerm.find_by_name("box")
						container_type = ContainerType.create(
							:name              => box_type, 
							:type              => ontology_term, 
							:can_have_children => true, 
							:retired           => false, 
							:shipable          => true 
						)
						puts "#NEW BOX TYPE #{container_type.inspect} added"
					end
					container_box = Container.create(
						:name                => box_label, 
						:barcode             => Barcode.generate(), 
						:container_type      => container_type, 
						:retired             => false, 
						:parent              => container_freezer, 
						:external_identifier => box_external_identifier,
						:shipped             => shipped
					)
					puts "#NEW BOX #{container_box.inspect} added"
				end
				if shipped == true
                    past_container = container_box
				end
			
				# create the tube container	
				container_tube = Container.find_by_name("#{sample_name}_container")
				puts "#WARNING: TUBE #{container_tube.name} found in the db" if container_tube
				if !container_tube
					container_type = ContainerType.find_by_name(container_tube_type)
					puts "#TUBE TYPE #{container_type.name} found in the db" if container_type
					if !container_type
						ontology_term = OntologyTerm.find_by_name("test tube")
						container_type = ContainerType.create(
							:name              => container_tube_type, 
							:type              => ontology_term, 
							:can_have_children => false, 
							:retired           => false, 
							:shipable          => true
						)
						puts "NEW TUBE TYPE #{container_type.inspect} added"
					end
					container_tube = Container.create(
						:name           => sample_name + "_container", 
						:barcode        => Barcode.generate(), 
						:container_type => container_type, 
						:retired        => false, 
						:parent         => container_box, 
						:shipped        => shipped
					)
					puts "#NEW TUBE #{container_tube.inspect} added"
				end

				# create samples
				
				sample = Sample.create(
					:name				=> sample_name, 
					:barcode			=> Barcode.generate(), 
					:taxon_id			=> taxon.id,  
					:container_id		=> container_tube.id, 
					:parent				=> Sample.find_by_name(parent), 
					:source_name		=> source_name, 
					:external_identifier=> sample_external_identifier, 
					:age 				=> age, 
					:ethnicity_id       => ethnicity_identifier,
					:race_id			=> race_identifier, 
					:strain_id          => strain_identifier,
					:genotype 			=> genotype, 
					:time_point			=> collection_time, 
					:treatments			=> treatments, 
					:replicate			=> replicate, 
					:sex           		=> bio_sex,
					:timeunit      		=> ageunit,
					:tissue_type   		=> tissue,
					:primary_cell  		=> primary,
					:material_type 		=> material,
					:quantity           => quantity,
					:protocols          => protocols,
					:notes              => notes,
					:tags               => tags
				)
				puts "Sample #{sample.name} created?"
				sample.studies << studies[study_identifier]	
				puts "#NEW SAMPLE #{sample.inspect} added"
				p "Assigned in study #{sample.studies}"

				#create shipment
				if shipped == true && !containers_shipped.has_key?(past_container)
                    ishipper = Person.find_by_identifier(shipper)
                    ireceiver = Person.find_by_identifier(receiver)
					puts "#SHIPPER #{ishipper.identifier} found in the db" if ishipper
					puts "#RECEIVER #{ireceiver.identifier} found in the db" if ireceiver
					if ishipper && ireceiver
						shipment = Shipment.create(:shipper_id => ishipper.id, :receiver_id => ireceiver.id, :past_container => past_container, :tracking_number => "#{ishipper.firstname}_to_#{ireceiver.firstname}")
						containers_shipped[past_container] = 1
						puts "#NEW SHIPMENT #{shipment.inspect} added"
					else
						puts "WARNING: Shipper-Receiver are not defined"
						break
					end
				end
			end
		end

		investigation_update2 = Investigation.update(investigation.id, {:imported => true})
		p "Investigation #{investigation_update2.identifier} is imported (#{investigation_update2.imported}) in the db."
		p "Timestamp >> #{(Time.now - start).to_i}"
		p "### Data import finished. ###"
	end
end
