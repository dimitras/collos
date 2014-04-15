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
#

class Study < ActiveRecord::Base
	attr_accessible :title, :identifier, :description, :investigation_id, :investigation_title

	belongs_to :investigation
	has_and_belongs_to_many :samples#, foreign_key: "id"
	has_and_belongs_to_many :people

	def investigation_title
		investigation.try(:title)
	end

	# versioned records
    has_paper_trail
end
