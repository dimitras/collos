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
