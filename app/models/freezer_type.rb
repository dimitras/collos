# == Schema Information
#
# Table name: freezer_types
#
#  id         :integer          not null, primary key
#  label      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FreezerType < ActiveRecord::Base
  attr_accessible :label

  has_many :box_types
end
