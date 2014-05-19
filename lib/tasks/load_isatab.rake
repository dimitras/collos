namespace :db do

	# USAGE: rake db:update_taxon_in_samples --trace
	desc "bulk update taxon in emanuelas samples - ONE TIME USE ONLY"
	task :update_taxon_in_samples  => :environment do
		samples = Sample.all # the database was empty before, so this is applied to all
		samples.each do |sample|
			# puts sample.id.to_s + " " + sample.taxon_id.to_s
			# sample_update = Sample.update(sample.id, { :taxon_id => 1 }) # from mouse to human
		end
	end
				

	require 'rubygems'
	require 'csv'

	# USAGE: rake db:load_isatab --trace
	desc "import isatab file data"
	task :load_isatab  => :environment do
		isatab_directory = "workspace/data/test/"
		investigations = {}
		investigation_file = "#{isatab_directory}investigation.csv"
		CSV.foreach(investigation_file, {:headers=>:first_row}) do |row|
			investigation_identifier = row[0]
			investigation_title = row[1]
			investigation_description = row[2]
			puts "#INVESTIGATIONS"
			puts "#{investigation_identifier} | #{investigation_title} | #{investigation_description}"
			puts
			# investigation = Investigation.create(:title => investigation_title, :identifier => investigation_identifier, :description => investigation_description)
			# investigations[investigation_identifier] = investigation
		end
		
		studies = {}
		studies_file = "#{isatab_directory}studies.csv"
		CSV.foreach(studies_file, {:headers=>:first_row}) do |row|
			study_identifier = row[0]
			study_title = row[1]
			study_description = row[2]
			investigation_identifier = row[3]
			puts "#STUDIES"
			puts "#{study_title} | #{study_identifier} | #{study_description} | #{investigation_identifier}"
			puts
			# study = Study.create(:title => study_title, :identifier => study_identifier, :description => study_description, :investigation_id => investigations[investigation_identifier].id)
			# studies[study_identifier] = study
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
			(line_1, line_2, line_3, city, province, state, zip, country) = row[6].split(",")
			email = row[7]
			phone = row[8]
			study_identifier = row[9]

			puts "#INVESTIGATORS"
			puts "#{identifier} | #{firstname} | #{lastname} | #{role} | #{phone} | #{email} | #{institution} | #{study_identifier}"
			puts
			# person = Person.create(:identifier => identifier, :firstname => firstname, :lastname => lastname, :type => role, :email => email, :phone => phone, :laboratory => laboratory, :institution => institution, :study_id => studies[study_identifier].id)
			# person_study = PeopleStudies.create(:person_id => person.id, :study_id =>studies[study_identifier].id)
			# investigation_person = InvestigationsPeople.create(:person_id => person.id, :investigation_id => investigations[investigation_identifier].id)

			container_institution = Container.find_by_name(institution)
			if !container_institution
				container_type = ContainerType.find_by_name("University")
				puts "#UNIVERSITY"
				puts "#{institution} | #{container_type}"
				puts
				# container_institution = Container.create(:name => institution, :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :shipped => false)
			end

			container_laboratory = Container.find_by_name(laboratory)
			if !container_laboratory
				container_type = ContainerType.find_by_name("Laboratory")
				puts "#LAB"
				puts "#{laboratory} | #{container_type}"
				puts
				# container_laboratory = Container.create(:name => laboratory, :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_institution, :shipped => false)
			end

			address_line1 = Address.find_by_line_1(line_1)
			if !address_line1
				puts "#ADDRESS"
				puts "#{line_1} | #{city}"
				puts
				# new_address = Address.create(:city => city, :country => country, :line_1 => line_1, :line_2 => line_2, :line_3 => line_3, :province => province, :state => state, :zip => zip)
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
			strain = row[4]
			genotype = row[5]
			sex = row[6]
			collection_time = row[7]
			treatments = row[8]
			replicate = row[9]
			tissue_type = row[10]
			primary_cell = row[11]
			material_type = row[12]
			age = row[13]
			age_unit = row[14]
			# protocol_refs = row[15].split('|')
			sample_external_identifier = row[16]
			if !row[17].nil?
				(container_tube_type, container_tube_dimensions) = row[17].split('|')
				(tube_container_x, tube_container_y) = container_tube_dimensions.split('x') if container_tube_dimensions
			end
			box_external_identifier = row[18]
			box_label = row[19]
			if !row[20].nil?
				(box_type, box_type_dimensions) = row[20].split('|')
				(box_container_x, box_container_y) = box_type_dimensions.split('x')
			end
			freezer_label = row[21]
			freezer_type = row[22]
			shipped = false
			if row[23] == "yes"
				shipped = true
			end
			shipper = row[24]
			receiver = row[25]
			collOS = row[26]
			study_identifier = row[27]
			
			# collOS says whether a sample is supposed to be entered in the db or not
			if collOS == "yes"
				taxon = Taxon.find_by_scientific_name(organism)
				if !taxon
					puts "#TAXON"
					puts "#{organism}"
					# taxon = Taxon.create(:scientific_name => organism)
				end
				
				age_unit_ontology_term = OntologyTerm.find_by_name(age_unit)
				# if the containers are not defined, the sample has been splitted or retired, either way it is labeled as retired and the containers cannot get created
				if freezer_type.nil? && box_type.nil? && container_tube_type.nil? && parent.nil?
					puts "HERE ::: #{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_types.join("|")} | #{organism} | #{protocol_refs.join("|")} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_type_dimensions} | #{box_label} | #{container_tube_type} | #{container_tube_dimensions} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier}"
					puts
					# sample = Sample.create(:name => sample_name, :barcode => Barcode.generate(), :taxon_id => taxon.id, :study_id => studies[study_identifier].id, :retired => true, :age => age, :age_id => age_unit_ontology_term.id, :strain => strain, :genotype => genotype, :time_point => collection_time, :treatments => treatments, :replicate => replicate, :tissue_type => tissue_type, :primary_cell => primary_cell, :material_type => material_type)
					next #TODO: to materials omos? 
				end

				container_freezer = Container.find_by_name(freezer_label)
				if !container_freezer
					container_type = ContainerType.find_by_name(freezer_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("freezer")
						# container_type = ContainerType.create(:name => freezer_type, :type => ontology_term, :can_have_children => true, :retired => false, :shipable => false)
					end
					puts "#FREEZER"
					puts "#{freezer_label} | #{container_type}"
					puts
					# container_freezer = Container.create(:name => freezer_label, :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_laboratory, :shipped => false)
				end
				
				container_box = Container.find_by_name(box_label)
				if !container_box
					container_type = ContainerType.find_by_name(box_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("box")
						# container_type = ContainerType.create(:name => box_type, :type => ontology_term, :can_have_children => true, :retired => false, :shipable => true, :x_dimension => box_container_x, :y_dimension => box_container_y)
					end
					puts "#BOX"
					puts "#{box_label} | #{container_type} | #{container_freezer}"
					puts
					# container_box = Container.create(:name => box_label, :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_freezer, :container_x => box_container_x, :container_y => box_container_y, :external_identifier => box_external_identifier)
				end
				
				container_type = ContainerType.find_by_name(container_tube_type)
				if !container_type
					ontology_term = OntologyTerm.find_by_name("test tube")
					# container_type = ContainerType.create(:name => container_tube_type, :type => ontology_term, :can_have_children => false, :retired => false, :shipable => true, :x_dimension => tube_container_x, :y_dimension => tube_container_y)
				end
				puts "#TUBE"
				puts "#{sample_name}_container | #{container_type} | #{container_box} | #{shipped}"
				puts
				# container_tube = Container.create(:name => sample_name + "_container", :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_box, :shipped => shipped, :container_x => tube_container_x, :container_y => tube_container_y)
				
				# TODO: has many materials, protocols ids to create
				puts "#SAMPLES"
				puts "#{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_types.join("|")} | #{organism} | #{protocol_refs.join("|")} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_container_x} | #{box_container_y} | #{box_label} | #{container_tube_type} | #{tube_container_x} | #{tube_container_y} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier} | #{sex}"
				puts

				sex_ontology_term = OntologyTerm.find_by_name(sex)
				# sample = Sample.create(:name => sample_name, :barcode => Barcode.generate() , :taxon_id => taxon.id,  :container_id => container_tube.id, :study_id => studies[study_identifier].id, :parent => Sample.find_by_name(parent), :sex_id => sex_ontology_term.id, :source_name => source_name, :container_x => tube_container_x, :container_y => tube_container_y, :external_identifier => sample_external_identifier, :age => age, :age_id => age_unit_ontology_term.id, :strain => strain, :genotype => genotype, :time_point => collection_time, :treatments => treatments, :replicate => replicate, :tissue_type => tissue_type, :primary_cell => primary_cell, :material_type => material_type)

				# sample_study = SamplesStudies.create(:sample_id => sample.id, :study_id => studies[study_identifier].id)
				

				### TODO first block is adjusted for one material type, second block is for multiple material types, material types table is not needed anymore.
				
				# if !MaterialType.find_by_name(material_type)
				# 	puts "#MATERIAL TYPE"
				# 	puts material_type
				# 	puts
				# 	# material_type = MaterialType.create(:name => material_type)
				# end
				# # sample_material_type = MaterialTypesSamples.create(:sample_id => sample.id, :material_type_id =>material_type.id)

				# material_types.each do |material_type_name|
				# 	material_type = MaterialType.find_by_name(material_type_name)
				# 	if !material_type
				# 		puts "#MATERIAL TYPES"
				# 		puts material_type_name
				# 		puts
				# 		# material_type = MaterialType.create(:name => material_type_name)
				# 	end
				# 	# sample_material_type = MaterialTypesSamples.create(:sample_id => sample.id, :material_type_id =>material_type.id)
				# end

				# TODO: we have to know which level of container has been shipped and the shipping info >> we can do it manually for now
				# if shipped == true
				# 	new_shipment = Shipment.create(:receiver_id, :receiver, :recieve_date, :ship_date, :shipper_id, :shipper, :tracking_number, :past_container, :new_container, :complete, :past_container_id, :new_container_id)
				# end

				# protocol_refs.each do |protocol|
					# new_protocol = Protocol.create(:name => protocol)
					# protocol_app = ProtocolApplication.create(:protocol_id => new_protocol.id)
				# end
				# sample_protocolapp = Sample_protocolapp.create(:sample_id => sample.id, :protocolapp_id => protocol_app.id)
			end
		end
	end

end
