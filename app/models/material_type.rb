# == Schema Information
#
# Table name: material_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tsv_content :tsvector
#

class MaterialType < ActiveRecord::Base
	attr_accessible :name

	has_and_belongs_to_many :samples

  	# Full text search of samples
	include PgSearch
	multisearchable against: [:name],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}

	pg_search_scope :search, against: [:name],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}
end
