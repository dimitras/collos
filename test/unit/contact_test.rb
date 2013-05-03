# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  fname      :string(255)
#  lname      :string(255)
#  email      :string(255)
#  address_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
