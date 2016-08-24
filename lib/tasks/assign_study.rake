namespace :db do	
	require 'rubygems'
	require 'csv'
	require 'roo'

	
	# USAGE: rake db:assign_study --trace
	desc "import spreadsheet"
	task :assign_study  => :environment do
		isatab_directory = "workspace/uploads/SCP2/"
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

        samples_file = "#{isatab_directory}/samples.csv"
        CSV.foreach(samples_file, {:headers=>:first_row}) do |row|
            sample_name = row[0]
            study_identifier = row[32]

            if Sample.exists?(name: sample_name)
                sample = Sample.find_by_name(sample_name)
			    sample.studies << studies[study_identifier]	
			    puts "#NOTICE: #{sample.name} exists. Added to #{sample.studies}"
            end
        end

		investigation_update2 = Investigation.update(investigation.id, {:imported => true})
		p "Investigation #{investigation_update2.identifier} is imported (#{investigation_update2.imported}) in the db."
		p "### Data import finished. ###"
	end
end
