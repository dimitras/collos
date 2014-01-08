# == Schema Information
#
# Table name: box_types
#
#  id          :integer          not null, primary key
#  label       :string(255)
#  dimension_x :integer
#  dimension_y :integer
#  freezer_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BoxType < ActiveRecord::Base
  attr_accessible :dimension_x, :dimension_y, :freezer_id, :label

  belongs_to :freezer_type
  has_many :container_types
end
