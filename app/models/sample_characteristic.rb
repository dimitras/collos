# == Schema Information
#
# Table name: sample_characteristics
#
#  id               :integer          not null, primary key
#  sample_id        :integer
#  ontology_term_id :integer
#  name             :string(255)
#  value            :string(255)
#  unit_type_id     :integer
#  unit             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SampleCharacteristic < ActiveRecord::Base
  attr_accessible :name, :unit, :value

  belongs_to :ontology_term
  belongs_to :unit_type, class_name: "OntologyTerm", foreign_key: "unit_type_id"
  belongs_to :sample

end
