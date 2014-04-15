# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  firstname   :string(255)
#  type        :string(255)
#  institution :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email       :string(255)
#  phone       :integer
#  lastname    :string(255)
#  user_id     :integer
#  study_id    :integer
#  tsv_content :tsvector
#

class Person < ActiveRecord::Base
	attr_accessible :firstname, :lastname, :type, :email, :phone, :institution, :user_id, :study_id

	has_and_belongs_to_many :studies
	has_and_belongs_to_many :investigations
	has_one :user

	# Full text search of samples
	include PgSearch
	multisearchable against: [:firstname, :lastname, :email, :institution],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}

	pg_search_scope :search, against: [:firstname, :lastname, :email, :institution],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}
end
