# == Schema Information
#
# Table name: boxes
#
#  id          :integer          not null, primary key
#  label       :string(255)
#  box_type_id :integer
#  freezer_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Box < ActiveRecord::Base
	attr_accessible :box_type_id, :freezer_id, :label

	belongs_to :box_type
	belongs_to :freezer
end
