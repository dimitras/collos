# == Schema Information
#
# Table name: samples_material_types
#
#  sample_id        :integer          not null
#  material_type_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SamplesMaterialTypes < ActiveRecord::Base
	attr_accessible :sample_id, :material_type_id
end
