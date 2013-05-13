# == Schema Information
#
# Table name: shipments
#
#  id              :integer          not null, primary key
#  tracking_number :string(255)
#  shipper_id      :integer
#  receiver_id     :integer
#  ship_date       :datetime
#  recieve_date    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
