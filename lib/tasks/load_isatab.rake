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
		investigations = {}
		investigation_file = "workspace/data/isatab_sample_tmp/investigation.csv"
		CSV.foreach(investigation_file, {:headers=>:first_row}) do |row|
			investigation_identifier = row[0]
			investigation_title = row[1]
			investigation_description = row[2]
			puts "#{investigation_identifier} | #{investigation_title} | #{investigation_description}"
			puts
			investigation = Investigation.create(:title => investigation_title, :identifier => investigation_identifier)
			investigations[investigation_identifier] = investigation
		end
		
		studies = {}
		studies_file = "workspace/data/isatab_sample_tmp/studies.csv"
		CSV.foreach(studies_file, {:headers=>:first_row}) do |row|
			study_identifier = row[0]
			study_title = row[1]
			study_description = row[3]
			investigation_identifier = row[6]
			puts "#{study_title} | #{study_identifier} | #{study_description} | #{investigation_identifier}"
			puts
			study = Study.create(:title => study_title, :identifier => study_identifier, :description => study_description, :investigation_id => investigations[investigation_identifier].id)
			studies[study_identifier] = study
		end
		
		# TODO: connect to user_id
		contacts_file = "workspace/data/isatab_sample_tmp/contacts.csv"
		CSV.foreach(contacts_file, {:headers=>:first_row}) do |row|
			identifier = row[0]
			lastname = row[2]
			role = row[4]
			phone = row[5]
			institution = row[6]
			firstname = row[8]
			email = row[11]
			study_identifier = row[13]
			puts "#{identifier} | #{firstname} | #{lastname} | #{role} | #{phone} | #{email} | #{institution} | #{study_identifier}"
			puts
			person = Person.create(:firstname => firstname, :lastname => lastname, :type => role, :email => email, :phone => phone, :institution => institution, :study_id => studies[study_identifier].id)
		end
		
		# TODO: fix parent for sample, if the samples.csv is not sorted, the parents are not assigned
		samples_file = "workspace/data/isatab_sample_tmp/samples.csv"
		CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
			identifier = row[0]
			sample_name = row[1]
			parent = row[2]
			source_name = row[3]
			material_types = row[4].split('|')
			organism = row[5]
			protocol_refs = row[6].split('|')
			freezer_type = row[7]
			freezer_label = row[8]
			if !row[9].nil?
				(box_type, box_type_dimensions) = row[9].split('|')
				(box_container_x, box_container_y) = box_type_dimensions.split('x')
			end
			box_label = row[10]
			if !row[11].nil?
				(container_tube_type, container_tube_dimensions) = row[11].split('|')
				(tube_container_x, tube_container_y) = container_tube_dimensions.split('x') if container_tube_dimensions
			end
			shipped = false
			if row[12] == "yes"
				shipped = true
			end
			receiver = row[13]
			collOS = row[14]
			sex = row[15]
			study_identifier = row[16]
			
			# collOS says whether a sample is supposed to be entered in the db or not
			if collOS == "yes"
				taxon = Taxon.find_by_scientific_name(organism)
				if !taxon
					puts "#{organism}"
					taxon = Taxon.create(:scientific_name => organism)
				end
				
				# if the containers are not defined, the sample has been splitted or retired, either way it is labeled as retired and the containers cannot get created
				if freezer_type.nil? && box_type.nil? && container_tube_type.nil? && parent.nil?
					puts "HERE ::: #{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_types.join("|")} | #{organism} | #{protocol_refs.join("|")} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_type_dimensions} | #{box_label} | #{container_tube_type} | #{container_tube_dimensions} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier}"
					puts
					sample = Sample.create(:name => sample_name, :barcode => Barcode.generate() , :taxon_id => taxon.id, :study_id => studies[study_identifier].id, :retired => true) 
					next #TODO: to materials omos? 
				end

				container_freezer = Container.find_by_name(freezer_label)
				if !container_freezer
					container_type = ContainerType.find_by_name(freezer_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("freezer")
						container_type = ContainerType.create(:name => freezer_type, :type => ontology_term, :can_have_children => true, :retired => false, :shipable => false)
					end
					puts "#{freezer_label} | #{container_type}"
					puts
					container_freezer = Container.create(:name => freezer_label, :barcode => Barcode.generate(), :container_type => container_type, :retired => false)
				end
				
				container_box = Container.find_by_name(box_label)
				if !container_box
					container_type = ContainerType.find_by_name(box_type)
					if !container_type
						ontology_term = OntologyTerm.find_by_name("box")
						container_type = ContainerType.create(:name => box_type, :type => ontology_term, :can_have_children => true, :retired => false, :shipable => true, :x_dimension => box_container_x, :y_dimension => box_container_y)
					end
					puts "#{box_label} | #{container_type} | #{container_freezer}"
					puts
					container_box = Container.create(:name => box_label, :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_freezer, :container_x => box_container_x, :container_y => box_container_y)
				end
				
				container_type = ContainerType.find_by_name(container_tube_type)
				if !container_type
					ontology_term = OntologyTerm.find_by_name("test tube")
					container_type = ContainerType.create(:name => container_tube_type, :type => ontology_term, :can_have_children => false, :retired => false, :shipable => true, :x_dimension => tube_container_x, :y_dimension => tube_container_y)
				end
				puts "#{sample_name}_container | #{container_type} | #{container_box} | #{shipped}"
				puts
				container_tube = Container.create(:name => sample_name + "_container", :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_box, :shipped => shipped, :container_x => tube_container_x, :container_y => tube_container_y)
				
				# TODO: has many materials, protocols ids to create
				puts "#{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_types.join("|")} | #{organism} | #{protocol_refs.join("|")} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_container_x} | #{box_container_y} | #{box_label} | #{container_tube_type} | #{tube_container_x} | #{tube_container_y} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier} | #{sex}"
				puts
				sex_ontology_term = OntologyTerm.find_by_name(sex)
				sample = Sample.create(:name => sample_name, :barcode => Barcode.generate() , :taxon_id => taxon.id,  :container_id => container_tube.id, :study_id => studies[study_identifier].id, :parent => Sample.find_by_name(parent), :sex => sex_ontology_term, :source_name => source_name, :container_x => tube_container_x, :container_y => tube_container_y)

				material_types.each do |material_type_name|
					material_type = MaterialType.find_by_name(material_type_name)
					if !material_type
						material_type = MaterialType.create(:name => material_type_name)
					end
					sample_material_type = SamplesMaterialTypes.create(:sample_id => sample.id, :material_type_id =>material_type.id)
				end

			end
		end
		
# protocol_refs.each do |protocol|
	# new_protocol = Protocol.create(:name => protocol)
	# protocol_app = ProtocolApplication.create(:protocol_id => new_protocol.id)
# end


# # # add associations
# # sample_protocolapp = Sample_protocolapp.create(:sample_id => sample.id, :protocolapp_id => protocol_app.id)

	end
end		

