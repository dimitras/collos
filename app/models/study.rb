# == Schema Information
#
# Table name: studies
#
#  id               :integer          not null, primary key
#  title            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  identifier       :string(255)
#  description      :text
#  investigation_id :integer
#  tsv_content      :tsvector
#

class Study < ActiveRecord::Base
	attr_accessible :title, :identifier, :description, :investigation_id, :investigation_title, :investigation

	belongs_to :investigation, :inverse_of => :studies
	has_and_belongs_to_many :samples#, foreign_key: "id"
	has_and_belongs_to_many :people

	validates_presence_of :investigation

	def investigation_title
		investigation.try(:title)
	end

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
