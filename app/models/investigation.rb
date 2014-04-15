# == Schema Information
#
# Table name: investigations
#
#  id          :integer          not null, primary key
#  title       :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identifier  :text
#  tsv_content :tsvector
#

class Investigation < ActiveRecord::Base
	attr_accessible :title, :identifier

  	has_many :studies, foreign_key: "id"
	has_many :samples
	has_and_belongs_to_many :people

	# Full text search of samples
	include PgSearch
	multisearchable against: [:title, :identifier],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}

	pg_search_scope :search, against: [:title, :identifier],
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
