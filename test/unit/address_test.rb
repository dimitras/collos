# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  line_1     :string(255)
#  line_2     :string(255)
#  line_3     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  province   :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
