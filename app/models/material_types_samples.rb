# == Schema Information
#
# Table name: material_types_samples
#
#  sample_id        :integer          not null
#  material_type_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class MaterialTypesSamples < ActiveRecord::Base
	attr_accessible :sample_id, :material_type_id
end
