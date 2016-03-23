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

	# versioned records
    has_paper_trail
end
