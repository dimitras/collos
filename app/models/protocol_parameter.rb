# == Schema Information
#
# Table name: protocol_parameters
#
#  id            :integer          not null, primary key
#  protocol_id   :integer
#  name          :string(255)
#  description   :string(255)
#  default_value :string(255)
#  unit_type_id  :integer
#  unit          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ProtocolParameter < ActiveRecord::Base
  belongs_to :protocol
  belongs_to :unit_type, class_name: "OntologyTerm", foreign_key: "unit_type_id"
  attr_accessible :default_value, :description, :name, :unit
end
