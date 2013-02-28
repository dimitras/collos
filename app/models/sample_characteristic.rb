class SampleCharacteristic < ActiveRecord::Base
  belongs_to :ontology_term
  belongs_to :unit_type
  attr_accessible :name, :unit, :value
end
