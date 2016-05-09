# == Schema Information
#
# Table name: investigations
#
#  id          :integer          not null, primary key
#  title       :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identifier  :string(255)
#  tsv_content :tsvector
#  description :text
#  imported    :boolean
#

class Investigation < ActiveRecord::Base
	attr_accessible :title, :identifier, :description, :study_ids, :imported

  	has_many :studies, :inverse_of => :investigation
	has_many :samples
	has_and_belongs_to_many :people

    accepts_nested_attributes_for :studies, :reject_if => lambda{|a| a[:identifier].blank?}, :allow_destroy => true

	# Full text search of samples
	include PgSearch
	multisearchable against: [:title, :identifier, :description],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}

	pg_search_scope :search, against: [:title, :identifier, :description],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}

	def self.rebuild_pg_search_documents
		#PgSearch::Document.delete_all(:searchable_type => self)
		find_each {|record| record.update_pg_search_document}
	end

	# versioned records
    has_paper_trail

# require 'rake'
# require 'rake/rdoctask'
# require 'rake/testtask'
# require 'tasks/rails'

# def capture_stdout
#   s = StringIO.new
#   oldstdout = $stdout
#   $stdout = s
#   yield
#   s.string
# ensure
#   $stdout = oldstdout
# end

# Rake.application.rake_require '../../lib/tasks/metric_fetcher'
# results = capture_stdout {Rake.application['metric_fetcher'].invoke}

    def self.import(file)

    	# http://railscasts.com/episodes/396-importing-csv-and-excel
    	# how to upload all info?
			# if isatab
			# 	run parser
			# 	run create tables
			# 	run rake
			# if csv or xls
			#   read all sheets
			# 	run rake

		# file type?

		# *****************************************
		# just run the rake file to load everything
		# make sure I have the correct format

		# parse
		spreadsheet = open_spreadsheet(file)

		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|

			row = Hash[[header, spreadsheet.row(i)].transpose]
			investigation = find_by_id(row["identifier"]) || new
			investigation.attributes = row.to_hash.slice(*accessible_attributes)
			investigation.save!
		end
	end

	def self.open_spreadsheet(file)

		# Roo::Excelx.new("*.xlsx")
		# Roo::Spreadsheet.open('*.xls')
		# Roo::CSV.new("*.csv")

		case File.extname(file.original_filename)
		when ".csv" then Csv.new(file.path, nil, :ignore)
		when ".xls" then Excel.new(file.path, nil, :ignore)
		when ".xlsx" then Excelx.new(file.path, nil, :ignore)
		else raise "Unknown file type: #{file.original_filename}"
		end
	end

end
