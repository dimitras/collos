# == Schema Information
#
# Table name: strains
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Strain < ActiveRecord::Base
	attr_accessible :name

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
