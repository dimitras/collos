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
#  laboratory  :string(255)
#  identifier  :string(255)
#

class Person < ActiveRecord::Base
	attr_accessible :identifier, :firstname, :lastname, :type, :email, :phone, :laboratory, :institution, :user_id, :study_id, :container, :container_id

	has_and_belongs_to_many :studies
	has_and_belongs_to_many :investigations
	has_one :user
	belongs_to :container
	
	has_many :shipments, class_name: "Shipment", foreign_key: "shipper_id"
	has_many :packages, class_name: "Shipment", foreign_key: "receiver_id"

	# Full text search of samples
	include PgSearch
	multisearchable against: [:firstname, :lastname, :email, :laboratory, :institution],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}

	pg_search_scope :search, against: [:firstname, :lastname, :email, :laboratory, :institution],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}
end
