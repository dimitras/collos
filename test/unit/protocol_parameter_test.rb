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

require 'test_helper'

class ProtocolParameterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
