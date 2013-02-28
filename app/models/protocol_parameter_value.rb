class ProtocolParameterValue < ActiveRecord::Base
  belongs_to :protocol_application
  belongs_to :protocol_parameter
  attr_accessible :unit, :value
end
