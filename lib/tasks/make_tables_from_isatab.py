"""

Convert an ISAtab directory to tables that can easily be imported in
rails.

"""

# USAGE: python lib/tasks/make_tables_from_isatab.py workspace/data/isatab_sample/ workspace/data/isatab_sample_tmp/studies.csv workspace/data/isatab_sample_tmp/contacts.csv workspace/data/isatab_sample_tmp/investigation.csv workspace/data/isatab_sample_tmp/samples.csv

from bcbio import isatab
import sys
import csv

class Sample:
	'''
	A sample that matches an ISAtab node
	'''
	
	def __init__(self, name):
		self.name = name
		self.attributes = {}
	
	def add_value_to_attribute(self, atr_name, atr_value):
		self.attributes.setdefault(atr_name, []).append(atr_value)
	
	def attribute(self, atr_name):
		return self.attributes[atr_name]
	
	def attribute_string(self, atr_name, delimiter="|"):
		return delimiter.join(self.attribute(atr_name))

def is_empty(any_structure):
    if any_structure:
        return False # Structure is not empty
    else:
        return True # Structure is empty

def main():
	# get directory from the command arguments and parse the files
	study_directory = str(sys.argv[1]) # data/ER-metab-v1_latest/
	studies_file = str(sys.argv[2])
	contacts_file = str(sys.argv[3])
	investigation_file = str(sys.argv[4])
	samples_file = str(sys.argv[5])
	
	# parse the isatab directory with python parser from isatools
	record = isatab.parse(study_directory)

	# get the attributes needed from the record
	investigation_info = record.metadata
	isatab_studies = record.studies

	# create tables with the needed parsed data
	# Studies metadata in investigation file
	studies_table = []
	for study in isatab_studies:
		study_table = []
		for value in study.metadata.values():
			study_table.append(value)
		studies_table.append(study_table)

	# write studies table to file
	with open(studies_file, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(['Study Title', 'Study Public Release Date', 'Study Identifier', 'Study Description', 'Study Submission Date', 'Study File Name'])
		for x in studies_table:
			a.writerow(x)

	# Contacts in investigation file
	contacts_table = []
	for study in isatab_studies:
		for contact in study.contacts:
			contact_table = []
			for key,value in contact.items():
				contact_table.append(value)
			contacts_table.append(contact_table)

	# write contacts table to file
	with open(contacts_file, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(['Comment[Lab]','Study Person Last Name','Study Person Mid Initials','Study Person Roles','Study Person Phone','Study Person Affiliation','Study Person Roles Term Accession Number','Study Person First Name','Study Person Fax','Study Person Address','Study Person Email','Study Person Roles Term Source REF'])
		for x in contacts_table:
			a.writerow(x)

	# Investigation metadata in investigation file
	investigation_table = []
	if not investigation_info:
		if len(studies_table) != 1:
			raise Exception('Investigation info empty and more than 1 studies provided. Check the files')
		investigation_table = [studies_table[0][2], studies_table[0][0], studies_table[0][3]]
	else:
		investigation_table = investigation_info.values()

	# write investigation table to file
	with open(investigation_file, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(['Investigation Identifier','Investigation Title','Investigation Description','Investigation Submission Date','Investigation Public Release Date','Comment [Created with configuration]','Comment [Last Opened With Configuration]','Comment [Created With Configuration]'])
		a.writerow(investigation_table)

	# Nodes metadata in studies file
	samples = []
	for study in isatab_studies:
		for node_record in study.nodes.values():
			sample_name = node_record.name
			sample = Sample(sample_name)
			
			for field_name, field_attributes in node_record.metadata.items():
				
				# Replace spaces with underscores to match the transformation that the 
				# ISAtab parser performs.
				field_name = field_name.replace(' ', '_')
				
				for field_attribute in field_attributes:
					try:
						field_attribute_dict = field_attribute._asdict()
						for attribute, value in field_attribute_dict.items():
							# check if the field name and the attribute name are not the same, to make a combined field name 
							if field_name != attribute:
								updated_field_name = field_name + '_' + attribute
							else:
								updated_field_name = field_name
								
							sample.add_value_to_attribute(updated_field_name, value)
					except AttributeError:
						sample.add_value_to_attribute(field_name, field_attribute)
					
			samples.append(sample)
	
	# write samples table to file
	with open(samples_file, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(['Sample_name','parent','Source_Name','Material_Type','organism','Protocol_REF','freezer_type','freezer_label','box_type','box_label','container_type','shipped','receiver','collOS'])
		for sample in samples:
			a.writerow([
						sample.attribute_string('Sample_Name'),
						sample.attribute_string('parent'),
						sample.attribute_string('Source_Name'),
						sample.attribute_string('Material_Type'),
						sample.attribute_string('organism'),
						sample.attribute_string('Protocol_REF'),
						sample.attribute_string('freezer_type'),
						sample.attribute_string('freezer_label'),
						sample.attribute_string('box_type'),
						sample.attribute_string('box_label'),
						sample.attribute_string('container_type'),
						sample.attribute_string('shipped'),
						sample.attribute_string('receiver'),
						sample.attribute_string('collOS')
					])

if __name__ == "__main__":
	main()
