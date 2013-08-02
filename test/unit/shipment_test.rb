# == Schema Information
#
# Table name: shipments
#
#  id              :integer          not null, primary key
#  barcode_string  :string(255)
#  tracking_number :string(255)
#  shipper_id      :integer
#  receiver_id     :integer
#  ship_date       :datetime
#  recieve_date    :datetime
#  tags            :string(500)
#  notes           :string(500)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tsv_content     :tsvector
#

require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
