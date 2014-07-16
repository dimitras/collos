"""

Convert an ISAtab directory to csv tables that can easily be imported in rails database.

"""

# USAGE: python lib/tasks/make_tables_from_isatab.py isatab_directory output_for_studies.csv output_for_contacts.csv output_for_investigation.csv output_for_samples.csv 

# python lib/tasks/make_tables_from_isatab.py workspace/data/ER_validation_study1/ investigation.csv studies.csv contacts.csv samples.csv 


from bcbio import isatab
import sys
import csv

class Record:
	'''
	A record that matches an ISAtab record in the ISAtab directory.
	As it is parsed by their parser.
	'''
	
	def __init__(self, isatab_record):
		self.isatab_record = isatab_record
		self._init_studies()
		self._init_investigation()
		
	def _init_investigation(self):
		if 'Investigation Identifier' not in self._metadata():
			# if the investigation identifier does not exist, use study's info (it should be only one)
			if len(self.studies) != 1:
				raise Exception('Investigation info is empty and there are more than 1 studies provided. Please enter Investigation info.')
			
			for study in self.studies:
				self.investigation = Investigation(study.attribute('Study Identifier'))
				self.investigation.store_attribute('Investigation Identifier', study.attribute('Study Identifier'))
				self.investigation.store_attribute('Investigation Title', study.attribute('Study Title'))
				self.investigation.store_attribute('Investigation Description', study.attribute('Study Description'))
		else:
			identifier = self._metadata()['Investigation Identifier']
			self.investigation = Investigation(identifier)
			for atr_name, atr_value in self._metadata().items():
				self.investigation.store_attribute(atr_name, atr_value)
		self.investigation.studies = self.studies

	def _init_studies(self):
		self.studies = [Study(isatab_study) for isatab_study in self._isatab_studies()]
	
	def _metadata(self):
		return self.isatab_record.metadata

	def _isatab_studies(self):
		return self.isatab_record.studies


class Investigation:
	'''
	An investigation is a group of one or more studies. 
	Matches an ISAtab investigation from the record metadata section in the investigation file.
	Could be empty if there is only one study involved.
	'''

	def __init__(self, identifier):
		self.identifier = identifier
		self.attributes = {}
		self.studies = None

	def store_attribute(self, atr_name, atr_value):
		self.attributes[atr_name] = atr_value

	def attribute(self, atr_name):
		if atr_name in self.attributes:
			return self.attributes[atr_name]
		else:
			return None;


class Study:
	'''
	A study of the investigation. 
	Contains many samples.
	Matches an ISAtab study from the studies section in the investigation file.
	'''

	def __init__(self, isatab_study):
		self._isatab_study = isatab_study
		self.identifier = None
		self.attributes = {}
		self.contacts = []
		self.samples = []
		self._build_from_isatab_study()
	
	def store_attribute(self, atr_name, atr_value):
		self.attributes[atr_name] = atr_value

	def attribute(self, atr_name):
		if atr_name in self.attributes:
			return self.attributes[atr_name]
		else:
			return None;
		
	def _build_from_isatab_study(self):
		self.identifier = self._isatab_study.metadata.values()[2]
		
		for atr_name, atr_value in self._isatab_study.metadata.items():
			self.store_attribute(atr_name, atr_value)
		
		self.contacts = [Contact(isatab_contact) for isatab_contact in self._isatab_study.contacts]
		self.samples = [Sample(isatab_node) for isatab_node in self._isatab_study.nodes.values()]

class Contact:
	'''
	A contact is person involved in the investigation or study.
	Many contacts may be involved in one investigation or study.
	Matches an ISAtab contact from the contacts section in the investigation file.
	'''

	def __init__(self, isatab_contact):
		self._isatab_contact = isatab_contact
		self.attributes = {}
		self.identifier = None
		self._build_from_isatab_contact()
	
	def store_attribute(self, atr_name, atr_value):
		self.attributes[atr_name] = atr_value

	def attribute(self, atr_name):
		if atr_name in self.attributes:
			return self.attributes[atr_name]
		else:
			return None;
	
	def _build_from_isatab_contact(self):
		self.attributes = self._isatab_contact
		self.identifier = self.attribute('Study Person Last Name') + self.attribute('Study Person Mid Initials') + self.attribute('Study Person First Name')


class Sample:
	'''
	A sample that matches an ISAtab node in the study file.
	'''
	
	def __init__(self, isatab_node):
		self._isatab_node = isatab_node
		self.identifier = None
		self.name = None
		self.attributes = {}
		self._build_from_isatab_node()
	
	def store_attribute(self, atr_name, atr_value):
		self.attributes.setdefault(atr_name, []).append(atr_value)
	
	def attribute(self, atr_name):
		print self.attributes[atr_name]
		return self.attributes[atr_name]
	
	def attribute_string(self, atr_name, delimiter="|"):
		# print self.attribute(atr_name)
		return delimiter.join(self.attribute(atr_name))
	
	def _build_from_isatab_node(self):
		self.name = self._isatab_node.name
		self.identifier = self.name
		
		for field_name, field_attributes in self._isatab_node.metadata.items():

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
							
						self.store_attribute(updated_field_name, value)
				except AttributeError:
					self.store_attribute(field_name, field_attribute)


########################################################
####################### FUNCTIONS ######################
########################################################
def write_investigation_to_csv(investigation, filename):
	'''
	Write investigation table to csv file
	'''
	with open(filename, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		fields = ['Investigation Identifier','Investigation Title','Investigation Description']
		a.writerow(fields)
		a.writerow([investigation.attribute(field) for field in fields])

def write_investigation_studies_to_csv(investigation, filename):
	'''
	Write studies list to a csv file.
	'''
	fields = ['Study Identifier', 'Study Title', 'Study Description', 'Study Design Type']
	
	with open(filename, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(fields + ['Investigation Identifier'])
		for study in investigation.studies:
			a.writerow([study.attribute(field) for field in fields] + [investigation.identifier])

def write_investigation_studies_contacts_to_csv(investigation, filename):
	'''
	Write contacts table to csv file
	'''
	fields = ['Comment[Lab]','Study Person Last Name','Study Person Mid Initials','Study Person Roles','Study Person Phone','Study Person Affiliation','Study Person First Name','Study Person Fax','Study Person Address','Study Person Email']
	
	with open(filename, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(['Contact Identifier'] + fields + ['Study Identifier'])
		for study in investigation.studies:
			for contact in study.contacts:
				a.writerow([contact.identifier] + [contact.attribute(field) for field in fields] + [study.identifier])

def write_investigation_studies_samples_to_csv(investigation, filename):	
	'''
	Write samples table to csv file
	'''
	fields = ['Sample_Name', 'parent', 'Source_Name', 'Material_Type', 'organism', 'Protocol_REF', 'freezer_type', 'freezer_label', 'box_type', 'box_label', 'box_external_identifier', 'container_type', 'sample_external_identifier', 'shipped', 'receiver', 'collOS', 'sex', 'strain', 'genetic_alteration', 'age', 'organism_part', 'NSAID', 'stimulus', 'dose', 'additive', 'dose1', 'collection_time']

	with open(filename, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(['Sample Identifier'] + fields + ['Study Identifier'])
		for study in investigation.studies:
			for sample in study.samples:
				a.writerow([sample.identifier] + [sample.attribute_string(field) for field in fields] + [study.identifier])


###################### MAIN METHOD ######################

def main():
	# get directory from the command arguments and parse the files
	study_directory = str(sys.argv[1]) # data/ER-metab-v1_latest/
	investigation_file = str(sys.argv[2])
	studies_file = str(sys.argv[3])
	contacts_file = str(sys.argv[4])
	samples_file = str(sys.argv[5])
	
	# parse the isatab directory with isatools parser and get the record
	record = Record(isatab.parse(study_directory))
	investigation = record.investigation
	
	# write investigation details to csv
	write_investigation_to_csv(investigation, investigation_file)
	
	# write investigation studies to csv
	write_investigation_studies_to_csv(investigation, studies_file)
	
	# write investigation studies contacts to csv
	write_investigation_studies_contacts_to_csv(investigation, contacts_file)
	
	# write investigation studies samples to csv
	write_investigation_studies_samples_to_csv(investigation, samples_file)

if __name__ == "__main__":
	main()
