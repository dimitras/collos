# == Schema Information
#
# Table name: barcodes
#
#  id          :integer          not null, primary key
#  barcode     :string(255)
#  barcode_set :integer          default(0)
#

require 'test_helper'

class BarcodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
