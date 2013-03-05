# == Schema Information
#
# Table name: protocols
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  accession   :string(255)
#  uri         :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ProtocolTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
