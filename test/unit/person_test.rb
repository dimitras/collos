# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  type        :string(255)
#  institution :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email       :string(255)
#  phone       :integer
#

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
