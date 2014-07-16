from bcbio import isatab
import sys
import csv
import pprint

# print isatab.__file__

# Get directory from the command arguments and parse the files
study_directory = str(sys.argv[1]) # data/ER-metab-v1_latest/
temp_file = str(sys.argv[2])

# Parse investigation files
def __init__(self, study_directory):
	self.study_directory = study_directory

def parse_files(self):
	isatab_record = isatab.parse(study_directory)
	return isatab_record

def write_to_temp(self):
	investigation_info = parse_files(study_directory).metadata
	isatab_studies = parse_files(study_directory).studies
	with open(temp_file, 'w') as fp:
		a = csv.writer(fp, delimiter=',')
		a.writerow(["investigation"])
		for key,value in investigation_info.items():
			investigation = [key, value]
			a.writerow(investigation)
		for study in isatab_studies:
			a.writerow(["metadata"])
			for key,value in study.metadata.items():
				md = [key, value]
				a.writerow(md)
			a.writerow(["contacts"])
			for contact in study.contacts:
				for key,value in contact.items():
					info = [key, value]
					a.writerow(info)
			a.writerow(["nodes"])
			for value in study.nodes.values():
				node = []
				for fieldname,fieldvalue in value.metadata.items():
					node.append([fieldname,fieldvalue])
				a.writerow(node)

write_to_temp(temp_file)

            
