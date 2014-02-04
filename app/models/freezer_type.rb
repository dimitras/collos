# == Schema Information
#
# Table name: freezer_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FreezerType < ActiveRecord::Base
	attr_accessible :name

	has_many :freezers, inverse_of: :freezer_types
end
