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

require 'test_helper'

class ProtocolParameterValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
