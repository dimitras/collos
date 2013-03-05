# == Schema Information
#
# Table name: protocol_applications
#
#  id             :integer          not null, primary key
#  protocol_id    :integer
#  operator_id    :integer
#  procedure_date :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class ProtocolApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
