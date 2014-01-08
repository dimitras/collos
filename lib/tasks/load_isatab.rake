namespace :db do

	# USAGE: rake db:update_taxon_in_samples --trace
	desc "update taxon in emanuelas samples"
	task :update_taxon_in_samples  => :environment do
		samples = Sample.all
		samples.each do |sample|
			puts sample.id.to_s + " " + sample.taxon_id.to_s
# 			sample_update = Sample.update(sample.id, { :taxon_id => 1 }) # from mouse to human
		end
	end
				

	require 'rubygems'
	require 'csv'

	# USAGE: rake db:load_isatab --trace
	desc "import isatab file data"
	task :load_isatab  => :environment do
		isatab_tmp_file = "data/temp_isatab.csv"
		in_section = 0
		CSV.foreach(isatab_tmp_file) do |row|
			if row[0].include? "investigation"
				in_section = 1
				next
			end
			if row[0].include? "metadata"
				in_section = 2
				next
			end
			if row[0].include? "contacts"
				in_section = 3
				next
			end
			if row[0].include? "nodes"
				in_section = 4
				next
			end

			case in_section
			when 1
				# :name, :person_id, :study_id
				if row[0] == "Investigation Title"
					investigation_name = row[1]
				end
			when 2
				# :title, :identifier, :description
				if row[0] == "Study Title"
					title = row[1]
				elsif row[0] == "Study Identifier"
					identifier = row[1]
				elsif row[0] == "Study Description"
					description = row[1]
				end
			when 3
				# :institution, :name, :type, :email, :phone
				if row[0] == "Study Person First Name"
					firstname = row[1]
				elsif row[0] == "Study Person Last Name"
					lastname = row[1]
				elsif row[0] == "Study Person Roles"
					role = row[1]
				elsif row[0] == "Study Person Phone"
					phone = row[1]
				elsif row[0] == "Study Person Email"
					email = row[1]
				elsif row[0] == "Study Person Affiliation"
					institution = row[1]
				end
			when 4
				# :name, :taxon, :taxon_id, :scientific_name, :common_name, :container, :container_id, :container_x, :container_y, :protocol_application, :protocol_application_id, :notes, :tags, :material_type

				for row.length-1 do |column|
					# ['Material Type', [Attrs(Material_Type='urine', Term_Source_REF='BTO', Term_Accession_Number='BTO:0001419'), Attrs(Material_Type='whole organism', Term_Source_REF='EFO', Term_Accession_Number='efo:EFO_0002906')]]
					# column.split('Attrs(')[1].
					# column.match(/Attrs/)
					# hashed_row = Hash[*row]
					row.scan(/.+Attrs\((.+)='(.+)'.+/)
				end
				# if row[0] == "Source Name"

				# elsif row[0] == "Sample Name"

				# elsif row[0] == "Material Type"

				# elsif row[0] == "organism"

				# elsif row[0] == "Protocol REF"

				# elsif row[0] == "freezer type"

				# elsif row[0] == "freezer label"

				# elsif row[0] == "box type"

				# elsif row[0] == "box label"

				# elsif row[0] == "container type"

				# elsif row[0] == "shipped"

				# elsif row[0] == "receiver"

				# elsif row[0] == "collOS"

				# end
			end


			# Study.create(:title => title, :identifier => identifier, :description => description)
			# Person.create(:institution => institution, :name => firstname+" "+lastname, :type => role, :email => email, :phone => phone)
			# Investigation.create(:name => investigation_name, :person_id => Person.id, :study_id => Study.id)

			# Sample.create()
			# Taxon.create()
			# ContainerType.create()
			# BoxType.create()
			# FreezerType.create()
			# Protocol.create()
			# ProtocolApplication.create()
			# ProtocolParameter.create()
			# Ontology.create()
			# OntologyTerm.create()
			# Shipment.create()
			# User.create()
			# Address.create()

		end
	end

end