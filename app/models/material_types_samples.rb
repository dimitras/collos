# == Schema Information
#
# Table name: material_types_samples
#
#  material_type_id :integer
#  sample_id        :integer
#

class MaterialTypesSamples < ActiveRecord::Base
	attr_accessible :sample_id, :material_type_id
end
