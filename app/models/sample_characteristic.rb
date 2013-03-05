# == Schema Information
#
# Table name: sample_characteristics
#
#  id               :integer          not null, primary key
#  ontology_term_id :integer
#  name             :string(255)
#  value            :string(255)
#  unit_type_id     :integer
#  unit             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SampleCharacteristic < ActiveRecord::Base
  belongs_to :ontology_term
  belongs_to :unit_type, class_name: "OntologyTerm", foreign_key: "unit_type_id"
  attr_accessible :name, :unit, :value
end
