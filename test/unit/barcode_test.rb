# == Schema Information
#
# Table name: barcodes
#
#  id               :integer          not null, primary key
#  barcode          :string(255)
#  barcode_set      :integer          default(0)
#  barcodeable_id   :integer
#  barcodeable_type :string(255)
#

require 'test_helper'

class BarcodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
