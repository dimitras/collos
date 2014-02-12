namespace :db do

	# USAGE: rake db:update_taxon_in_samples --trace
	desc "bulk update taxon in emanuelas samples"
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

		Dir["workspace/data/isatab_sample_tmp/*.csv"].each do |file|
			file_pathname = Pathname.new(file)
			filename = file_pathname.basename
			CSV.foreach(file, {:headers=>:first_row}) do |row|
				case filename

				when filename == "investigation.csv"
					investigation_identifier = row[0]
					investigation_title = row[1]
					investigation_description = row[2]
					puts "#{investigation_identifier} | #{investigation_title} | #{investigation_description}"
					

				when filename == "studies.csv"
					study_title = row[0]
					study_identifier = row[2]
					study_description = row[3]
					puts "#{study_title} | #{study_identifier} | #{study_description}"
					

				when filename == "contacts.csv"
					firstname = row[7]
					lastname = row[1]
					role = row[3]
					phone = row[4]
					email = row[10]
					institution = row[5]
					puts "#{firstname} | #{lastname} | #{role} | {phone} | #{email} | #{institution}"


				when filename == "samples.csv" 
					sample_name = row[0]
					parent = row[1]
					source_name = row[2]
					material_types = row[3].split(',')
					organism = row[4]
					protocol_refs = row[5].split(',')
					freezer_type = row[6]
					freezer_label = row[7]
					(box_type, box_type_dimensions) = row[8].split('|')
					box_label = row[9]
					(container_type, container_type_dimensions) = row[10].split('|')
					shipped = row[11]
					receiver = row[12]
					collOS = row[13]
					puts "#{sample_name} | #{parent} | #{source_name} | {material_types} | #{organism} | #{protocol_refs} | #{freezer_type} | #{freezer_label} | #{box_type} | #{box_type_dimensions} | #{box_label} | #{container_type} | #{container_type_dimensions} | #{shipped} | #{receiver} | #{collOS}"

				end

				# feed the database
				# study = Study.create(:title => study_title, :identifier => study_identifier, :description => study_description)
				# person = Person.create(:firstname => firstname, :lastname => lastname, :type => role, :email => email, :phone => phone, :institution => institution)
				# investigation = Investigation.create(:name => investigation_title, :investigation_identifier => investigation_identifier, :investigation_description => investigation_description, :person_id => person.id, :study_id => study.id) # has many people, has many studies
				
				# # TODO: check if taxon exists, otherwise enter, and pick the id
				# taxon = Taxon.create()
				# # 
				# freezer_type = FreezerType.create()
				# freezer = Freezer.create()
				# box_type = BoxType.create()
				# box = Box.create()
				# container_type = ContainerType.create()
				# container = Container.create()
				# # 
				# protocol = Protocol.create()
				# protocol_app = ProtocolApplication.create()
				# # add it
				# material_type = Material_Type.create()
				# # TODO: add barcode generation here
				# sample = Sample.create(:name => sample_name, :barcode_string => ? , :taxon_id => taxon.id,  :container_id, :container_x, :container_y, :protocol_application_id, :notes, :tags, :material_type_id)
				
				# # add associations
				# sample_protocolapp = Sample_protocolapp.create(:sample_id => sample.id, :protocolapp_id => protocol_app.id)
				# sample_materialtype = Sample_materialtype.create(:sample_id => sample.id, :material_type_id => material_type.id)
				# # 
				# Ontology.create()
				# OntologyTerm.create()
				# Shipment.create()
				# User.create()
				# Address.create()

			end
		end

	end
end		

