# == Schema Information
#
# Table name: studies
#
#  id          :integer          not null, primary key
#  title       :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identifier  :string(255)
#  description :text
#

class Study < ActiveRecord::Base
	attr_accessible :title, :identifier, :description

	has_many :investigations
	has_many :samples
	has_and_belongs_to_many :people
end
