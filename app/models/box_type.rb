# == Schema Information
#
# Table name: box_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  dimension_x :integer
#  dimension_y :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BoxType < ActiveRecord::Base
	attr_accessible :dimension_x, :dimension_y, :name

	has_many :boxes, inverse_of: :box_types
end
