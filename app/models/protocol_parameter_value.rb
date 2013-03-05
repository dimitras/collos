# == Schema Information
#
# Table name: protocol_parameter_values
#
#  id                      :integer          not null, primary key
#  protocol_application_id :integer
#  protocol_parameter_id   :integer
#  value                   :string(255)
#  unit                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ProtocolParameterValue < ActiveRecord::Base
  belongs_to :protocol_application
  belongs_to :protocol_parameter
  attr_accessible :unit, :value
end
