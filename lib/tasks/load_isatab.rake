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
			end
			box_label = row[10]
			if !row[11].nil?
				(container_tube_type, container_tube_dimensions) = row[11].split('|')
			end
			shipped = false
			if row[12] == "yes"
				shipped = true
			end
			receiver = row[13]
			collOS = row[14]
			study_identifier = row[15]
			
			taxon = Taxon.find_by_scientific_name(organism)
			if !taxon
				taxon = Taxon.create(:ncbi_id => nil, :scientific_name => organism, :common_name => nil)
			end
			
			container_freezer = Container.find_by_name(freezer_label)
			if !container_freezer
				container_type = ContainerType.find_by_name(freezer_type)
				if !container_type
					ontology_term = OntologyTerm.find_by_name("freezer")
					container_type = ContainerType.create(:name => freezer_type, :type => ontology_term, :can_have_children => true, :retired => false, :shipable => false)
				end
				container_freezer = Container.create(:name => freezer_label, :barcode => Barcode.generate(), :container_type => container_type, :retired => false)
			end
			
			container_box = Container.find_by_name(box_label)
			if !container_box
				container_type = ContainerType.find_by_name(box_type)
				if !container_type
					ontology_term = OntologyTerm.find_by_name("box")
					container_type = ContainerType.create(:name => box_type, :type => ontology_term, :can_have_children => true, :retired => false, :shipable => true)
				end
				container_box = Container.create(:name => box_label, :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_freezer)
			end
			
			container_type = ContainerType.find_by_name(container_tube_type)
			if !container_type
				ontology_term = OntologyTerm.find_by_name("test tube")
				container_type = ContainerType.create(:name => container_tube_type, :type => ontology_term, :can_have_children => false, :retired => false, :shipable => true)
			end
			container_tube = Container.create(:name => sample_name, :barcode => Barcode.generate(), :container_type => container_type, :retired => false, :parent => container_box, :shipped => shipped)
			
			puts "#{identifier} | #{sample_name} | #{parent} | #{source_name} | #{material_types.join("|")} | #{organism} | #{protocol_refs.join("|")} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_type_dimensions} | #{box_label} | #{container_tube_type} | #{container_tube_dimensions} | #{shipped} | #{receiver} | #{collOS} | #{study_identifier}"
			puts taxon.id
			puts container_tube.id
			puts studies[study_identifier].id
			sample = Sample.create(:name => sample_name, :barcode => Barcode.generate() , :taxon_id => taxon.id,  :container_id => container_tube.id, :study_id => studies[study_identifier].id)
		end
		
# 				protocol_refs.each do |protocol|
# # 					new_protocol = Protocol.create(:name => protocol)
# # 					protocol_app = ProtocolApplication.create(:protocol_id => new_protocol.id)
# 				end
# 				
# 				material_types.each do |material_type|
# # 					new_material_type = Material_Type.create(:name => material_type)
# 				end
# 				
# 				# TODO: add barcode generation here
# 				# TODO: has many materials, protocols ids to create
# 				sample = Sample.create(:name => sample_name, :barcode_string => ? , :taxon_id => organism_id,  :container_id => ?, :container_x => ?, :container_y => ?, :protocol_application_id => ?, :notes => nil, :tags => nil, :material_type_id => new_material_type.id)
# 				
# 				# # add associations
# 				# sample_protocolapp = Sample_protocolapp.create(:sample_id => sample.id, :protocolapp_id => protocol_app.id)
# 				# sample_materialtype = Sample_materialtype.create(:sample_id => sample.id, :material_type_id => material_type.id)
# 
# 			end
# 		end

	end
end		

